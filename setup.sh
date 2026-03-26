#!/usr/bin/env bash
# ==============================================================================
# Breezeware Skills — Auto-Detecting Plugin Setup
# ==============================================================================
# Scans a target project for marker files and installs only the relevant
# Claude Code skills from the breezeware-claude-plugins repository.
#
# Usage:
#   ./setup.sh /path/to/target-project              # Detect & install
#   ./setup.sh --dry-run /path/to/target-project     # Preview only
#   ./setup.sh --packs spring-boot,react /path/to    # Force specific packs
#   ./setup.sh --list-packs                          # Show all packs
#   ./setup.sh --symlink /path/to/target-project     # Symlink instead of copy
# ==============================================================================

set -euo pipefail

# -- Constants -----------------------------------------------------------------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REGISTRY="$SCRIPT_DIR/plugin-registry.json"
TEMPLATE="$SCRIPT_DIR/CLAUDE.md.template"
SKILLS_DIR="$SCRIPT_DIR/.claude/skills"

# -- Colors --------------------------------------------------------------------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# -- Globals -------------------------------------------------------------------
DRY_RUN=false
USE_SYMLINK=false
FORCE_PACKS=""
TARGET=""
ACTIVATED_PACKS=()
ACTIVATED_SKILLS=()
TOTAL_INSTALLED=0

# ==============================================================================
# Utility Functions
# ==============================================================================

print_header() {
    echo ""
    echo -e "${BOLD}${CYAN}╔══════════════════════════════════════════════════╗${NC}"
    echo -e "${BOLD}${CYAN}║   Breezeware Skills — Plugin Setup               ║${NC}"
    echo -e "${BOLD}${CYAN}╚══════════════════════════════════════════════════╝${NC}"
    echo ""
}

log_info() {
    echo -e "  ${BLUE}ℹ${NC}  $1"
}

log_success() {
    echo -e "  ${GREEN}✓${NC}  $1"
}

log_warning() {
    echo -e "  ${YELLOW}!${NC}  $1"
}

log_error() {
    echo -e "  ${RED}✗${NC}  $1"
}

log_detect() {
    echo -e "  ${GREEN}⬤${NC}  $1"
}

log_skip() {
    echo -e "  ${YELLOW}○${NC}  $1"
}

check_jq() {
    if ! command -v jq &> /dev/null; then
        log_error "jq is required but not installed."
        echo ""
        echo "  Install jq:"
        echo "    macOS:   brew install jq"
        echo "    Ubuntu:  sudo apt-get install jq"
        echo "    CentOS:  sudo yum install jq"
        echo ""
        exit 1
    fi
}

# ==============================================================================
# Detection Functions
# ==============================================================================

detect_file_exists() {
    local target="$1"
    local pattern="$2"
    local content_match="${3:-}"

    if [ -f "$target/$pattern" ]; then
        if [ -z "$content_match" ]; then
            return 0
        else
            grep -qi "$content_match" "$target/$pattern" 2>/dev/null
            return $?
        fi
    fi
    return 1
}

detect_dir_exists() {
    local target="$1"
    local pattern="$2"

    [ -d "$target/$pattern" ]
}

detect_package_json_dep() {
    local target="$1"
    local dep_name="$2"
    local exclude_dep="${3:-}"

    local pkg="$target/package.json"
    if [ ! -f "$pkg" ]; then
        return 1
    fi

    # Check if the dependency exists in dependencies or devDependencies
    local found
    found=$(jq -e "(.dependencies[\"$dep_name\"] // .devDependencies[\"$dep_name\"]) != null" "$pkg" 2>/dev/null)

    if [ "$found" != "true" ]; then
        return 1
    fi

    # Check exclusion
    if [ -n "$exclude_dep" ]; then
        local excluded
        excluded=$(jq -e "(.dependencies[\"$exclude_dep\"] // .devDependencies[\"$exclude_dep\"]) != null" "$pkg" 2>/dev/null)
        if [ "$excluded" = "true" ]; then
            return 1
        fi
    fi

    return 0
}

detect_glob_exists() {
    local target="$1"
    local pattern="$2"
    local max_depth="${3:-4}"

    local result
    result=$(find "$target" -maxdepth "$max_depth" -name "$pattern" \
        -not -path "*/node_modules/*" \
        -not -path "*/.git/*" \
        -not -path "*/build/*" \
        -not -path "*/target/*" \
        -not -path "*/dist/*" \
        -not -path "*/.next/*" \
        -not -path "*/out/*" \
        2>/dev/null | head -1)

    [ -n "$result" ]
}

# ==============================================================================
# Pack Detection
# ==============================================================================

run_detection_rule() {
    local target="$1"
    local rule_json="$2"

    local rule_type
    rule_type=$(echo "$rule_json" | jq -r '.type')

    case "$rule_type" in
        file_exists)
            local pattern content_match
            pattern=$(echo "$rule_json" | jq -r '.pattern')
            content_match=$(echo "$rule_json" | jq -r '.content_match // empty')
            detect_file_exists "$target" "$pattern" "$content_match"
            ;;
        dir_exists)
            local pattern
            pattern=$(echo "$rule_json" | jq -r '.pattern')
            detect_dir_exists "$target" "$pattern"
            ;;
        package_json_dep)
            local name exclude
            name=$(echo "$rule_json" | jq -r '.name')
            exclude=$(echo "$rule_json" | jq -r '.exclude_if_dep // empty')
            detect_package_json_dep "$target" "$name" "$exclude"
            ;;
        glob_exists)
            local pattern max_depth
            pattern=$(echo "$rule_json" | jq -r '.pattern')
            max_depth=$(echo "$rule_json" | jq -r '.max_depth // 4')
            detect_glob_exists "$target" "$pattern" "$max_depth"
            ;;
        *)
            log_warning "Unknown detection rule type: $rule_type"
            return 1
            ;;
    esac
}

detect_pack() {
    local target="$1"
    local pack_name="$2"

    # Check if always_active
    local always_active
    always_active=$(jq -r ".packs[\"$pack_name\"].always_active // false" "$REGISTRY")
    if [ "$always_active" = "true" ]; then
        return 0
    fi

    # Run detection rules (OR logic — any match activates)
    local rule_count
    rule_count=$(jq -r ".packs[\"$pack_name\"].detect | length" "$REGISTRY")

    for ((i = 0; i < rule_count; i++)); do
        local rule
        rule=$(jq -c ".packs[\"$pack_name\"].detect[$i]" "$REGISTRY")

        if run_detection_rule "$target" "$rule"; then
            return 0
        fi
    done

    return 1
}

get_detection_reason() {
    local target="$1"
    local pack_name="$2"

    local always_active
    always_active=$(jq -r ".packs[\"$pack_name\"].always_active // false" "$REGISTRY")
    if [ "$always_active" = "true" ]; then
        echo "always active"
        return
    fi

    local rule_count
    rule_count=$(jq -r ".packs[\"$pack_name\"].detect | length" "$REGISTRY")

    for ((i = 0; i < rule_count; i++)); do
        local rule
        rule=$(jq -c ".packs[\"$pack_name\"].detect[$i]" "$REGISTRY")

        if run_detection_rule "$target" "$rule"; then
            local rule_type pattern content_match name
            rule_type=$(echo "$rule" | jq -r '.type')
            case "$rule_type" in
                file_exists)
                    pattern=$(echo "$rule" | jq -r '.pattern')
                    content_match=$(echo "$rule" | jq -r '.content_match // empty')
                    if [ -n "$content_match" ]; then
                        echo "$pattern contains \"$content_match\""
                    else
                        echo "$pattern found"
                    fi
                    ;;
                dir_exists)
                    pattern=$(echo "$rule" | jq -r '.pattern')
                    echo "$pattern/ directory found"
                    ;;
                package_json_dep)
                    name=$(echo "$rule" | jq -r '.name')
                    echo "package.json has \"$name\" dependency"
                    ;;
                glob_exists)
                    pattern=$(echo "$rule" | jq -r '.pattern')
                    echo "$pattern files found"
                    ;;
            esac
            return
        fi
    done
    echo "unknown"
}

# ==============================================================================
# Installation
# ==============================================================================

install_skills() {
    local target="$1"
    local target_skills="$target/.claude/skills"

    # Create target skills directory
    mkdir -p "$target_skills"

    for skill in "${ACTIVATED_SKILLS[@]}"; do
        local source="$SKILLS_DIR/$skill"

        if [ ! -d "$source" ]; then
            log_warning "Skill directory not found: $skill (skipping)"
            continue
        fi

        local dest="$target_skills/$skill"

        # Remove existing if present
        if [ -e "$dest" ] || [ -L "$dest" ]; then
            rm -rf "$dest"
        fi

        if [ "$USE_SYMLINK" = true ]; then
            ln -s "$source" "$dest"
            log_success "Linked: $skill"
        else
            cp -r "$source" "$dest"
            log_success "Copied: $skill"
        fi

        TOTAL_INSTALLED=$((TOTAL_INSTALLED + 1))
    done
}

generate_claude_md() {
    local target="$1"
    local target_claude_md="$target/CLAUDE.md"

    # Build skills list
    local skills_list=""
    for skill in "${ACTIVATED_SKILLS[@]}"; do
        local desc
        # Find which pack this skill belongs to and get its description
        desc=$(jq -r "
            .packs | to_entries[] |
            select(.value.skills[\"$skill\"] != null) |
            .value.skills[\"$skill\"]
        " "$REGISTRY" | head -1)

        if [ -n "$desc" ]; then
            skills_list="${skills_list}- \`/$skill\` — $desc\n"
        fi
    done

    # Check if target already has CLAUDE.md with markers
    if [ -f "$target_claude_md" ] && grep -q "BREEZEWARE-SKILLS-START" "$target_claude_md"; then
        # Replace content between markers
        local temp_file
        temp_file=$(mktemp)

        # Write everything before the marker
        sed -n '1,/BREEZEWARE-SKILLS-START/p' "$target_claude_md" > "$temp_file"

        # Write the skills section
        echo "## Available Skills" >> "$temp_file"
        echo "The following custom skills are available in \`.claude/skills/\`:" >> "$temp_file"
        echo -e "$skills_list" >> "$temp_file"

        # Write everything after the end marker
        sed -n '/BREEZEWARE-SKILLS-END/,$p' "$target_claude_md" >> "$temp_file"

        mv "$temp_file" "$target_claude_md"
        log_success "Updated existing CLAUDE.md (replaced skills section)"
    elif [ -f "$TEMPLATE" ]; then
        # Generate from template
        local temp_file
        temp_file=$(mktemp)

        # Replace the placeholder
        while IFS= read -r line; do
            if [[ "$line" == *"{{SKILLS_LIST}}"* ]]; then
                echo -e "$skills_list" >> "$temp_file"
            else
                echo "$line" >> "$temp_file"
            fi
        done < "$TEMPLATE"

        mv "$temp_file" "$target_claude_md"
        log_success "Generated CLAUDE.md from template"
    else
        log_warning "No template found, skipping CLAUDE.md generation"
    fi
}

# ==============================================================================
# Commands
# ==============================================================================

cmd_list_packs() {
    print_header
    echo -e "${BOLD}Available Plugin Packs:${NC}"
    echo ""

    local packs
    packs=$(jq -r '.packs | keys[]' "$REGISTRY")

    for pack in $packs; do
        local desc always_active skill_count
        desc=$(jq -r ".packs[\"$pack\"].description" "$REGISTRY")
        always_active=$(jq -r ".packs[\"$pack\"].always_active // false" "$REGISTRY")
        skill_count=$(jq -r ".packs[\"$pack\"].skills | keys | length" "$REGISTRY")

        if [ "$always_active" = "true" ]; then
            echo -e "  ${GREEN}●${NC} ${BOLD}$pack${NC} (always active) — $desc"
        else
            echo -e "  ${BLUE}●${NC} ${BOLD}$pack${NC} — $desc"
        fi

        # List skills in the pack
        local skills
        skills=$(jq -r ".packs[\"$pack\"].skills | keys[]" "$REGISTRY")
        for skill in $skills; do
            local skill_desc
            skill_desc=$(jq -r ".packs[\"$pack\"].skills[\"$skill\"]" "$REGISTRY")
            echo -e "      /$skill — $skill_desc"
        done

        # List detection rules
        if [ "$always_active" != "true" ]; then
            echo -e "      ${YELLOW}Detects:${NC}"
            local rule_count
            rule_count=$(jq -r ".packs[\"$pack\"].detect | length" "$REGISTRY")
            for ((i = 0; i < rule_count; i++)); do
                local rule_type pattern
                rule_type=$(jq -r ".packs[\"$pack\"].detect[$i].type" "$REGISTRY")
                case "$rule_type" in
                    file_exists)
                        pattern=$(jq -r ".packs[\"$pack\"].detect[$i].pattern" "$REGISTRY")
                        local cm
                        cm=$(jq -r ".packs[\"$pack\"].detect[$i].content_match // empty" "$REGISTRY")
                        if [ -n "$cm" ]; then
                            echo "        - $pattern containing \"$cm\""
                        else
                            echo "        - $pattern exists"
                        fi
                        ;;
                    dir_exists)
                        pattern=$(jq -r ".packs[\"$pack\"].detect[$i].pattern" "$REGISTRY")
                        echo "        - $pattern/ directory exists"
                        ;;
                    package_json_dep)
                        local name
                        name=$(jq -r ".packs[\"$pack\"].detect[$i].name" "$REGISTRY")
                        echo "        - package.json has \"$name\""
                        ;;
                    glob_exists)
                        pattern=$(jq -r ".packs[\"$pack\"].detect[$i].pattern" "$REGISTRY")
                        echo "        - $pattern files exist"
                        ;;
                esac
            done
        fi
        echo ""
    done
}

cmd_setup() {
    local target="$1"

    print_header

    # Validate target
    if [ ! -d "$target" ]; then
        log_error "Target directory does not exist: $target"
        exit 1
    fi

    target=$(cd "$target" && pwd)  # Resolve to absolute path

    echo -e "${BOLD}Scanning:${NC} $target"
    echo ""

    # Get all pack names
    local packs
    packs=$(jq -r '.packs | keys[]' "$REGISTRY")

    # Determine which packs to activate
    if [ -n "$FORCE_PACKS" ]; then
        echo -e "${BOLD}Mode:${NC} Forced packs"
        echo ""

        # Always include common
        ACTIVATED_PACKS+=("common")
        log_detect "common — always active"

        IFS=',' read -ra forced <<< "$FORCE_PACKS"
        for pack in "${forced[@]}"; do
            pack=$(echo "$pack" | xargs)  # trim whitespace
            if jq -e ".packs[\"$pack\"]" "$REGISTRY" > /dev/null 2>&1; then
                ACTIVATED_PACKS+=("$pack")
                log_detect "$pack — forced"
            else
                log_warning "Unknown pack: $pack (skipping)"
            fi
        done
    else
        echo -e "${BOLD}Mode:${NC} Auto-detect"
        echo ""

        for pack in $packs; do
            if detect_pack "$target" "$pack"; then
                ACTIVATED_PACKS+=("$pack")
                local reason
                reason=$(get_detection_reason "$target" "$pack")
                log_detect "$pack — $reason"
            else
                log_skip "$pack — not detected"
            fi
        done
    fi

    echo ""

    # Collect all skills from activated packs (deduplicated)
    local all_skills=""
    for pack in "${ACTIVATED_PACKS[@]}"; do
        local skills
        skills=$(jq -r ".packs[\"$pack\"].skills | keys[]" "$REGISTRY")
        for skill in $skills; do
            all_skills="$all_skills $skill"
        done
    done

    # Deduplicate and sort
    local sorted_unique
    sorted_unique=$(echo "$all_skills" | tr ' ' '\n' | grep -v '^$' | sort -u)
    while IFS= read -r skill; do
        [ -n "$skill" ] && ACTIVATED_SKILLS+=("$skill")
    done <<< "$sorted_unique"

    # Summary
    echo -e "${BOLD}Activated Packs:${NC} ${ACTIVATED_PACKS[*]}"
    echo -e "${BOLD}Skills (${#ACTIVATED_SKILLS[@]}):${NC}"
    for skill in "${ACTIVATED_SKILLS[@]}"; do
        echo "  - /$skill"
    done
    echo ""

    if [ "$DRY_RUN" = true ]; then
        echo -e "${YELLOW}${BOLD}DRY RUN — no changes made${NC}"
        echo ""
        echo "Run without --dry-run to install."
        return
    fi

    # Install
    echo -e "${BOLD}Installing skills...${NC}"
    install_skills "$target"
    echo ""

    # Generate CLAUDE.md
    echo -e "${BOLD}Generating CLAUDE.md...${NC}"
    generate_claude_md "$target"
    echo ""

    # Final summary
    echo -e "${GREEN}${BOLD}Done!${NC} Installed ${TOTAL_INSTALLED} skills to $target/.claude/skills/"
    echo ""
    echo "Next steps:"
    echo "  1. Review the generated CLAUDE.md"
    echo "  2. Commit .claude/ and CLAUDE.md to your repo"
    echo ""
}

# ==============================================================================
# Argument Parsing
# ==============================================================================

show_usage() {
    echo "Usage: $(basename "$0") [OPTIONS] /path/to/target-project"
    echo ""
    echo "Options:"
    echo "  --dry-run         Preview detected packs without installing"
    echo "  --packs LIST      Force specific packs (comma-separated)"
    echo "  --symlink         Symlink skills instead of copying"
    echo "  --list-packs      Show all available plugin packs"
    echo "  --help            Show this help message"
    echo ""
    echo "Examples:"
    echo "  $(basename "$0") ~/projects/my-spring-app"
    echo "  $(basename "$0") --dry-run ~/projects/my-react-app"
    echo "  $(basename "$0") --packs spring-boot,cucumber ~/projects/my-app"
    echo "  $(basename "$0") --list-packs"
}

main() {
    check_jq

    if [ ! -f "$REGISTRY" ]; then
        log_error "Plugin registry not found: $REGISTRY"
        exit 1
    fi

    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --dry-run)
                DRY_RUN=true
                shift
                ;;
            --symlink)
                USE_SYMLINK=true
                shift
                ;;
            --packs)
                FORCE_PACKS="$2"
                shift 2
                ;;
            --list-packs)
                cmd_list_packs
                exit 0
                ;;
            --help|-h)
                show_usage
                exit 0
                ;;
            -*)
                log_error "Unknown option: $1"
                show_usage
                exit 1
                ;;
            *)
                TARGET="$1"
                shift
                ;;
        esac
    done

    if [ -z "$TARGET" ]; then
        show_usage
        exit 1
    fi

    cmd_setup "$TARGET"
}

main "$@"
