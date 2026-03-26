#!/usr/bin/env bash
# Detect Spring Boot project and inject context

if [ -f "pom.xml" ] || [ -d "src/main/java" ]; then
    echo "[Spring Boot project detected]"
    echo ""
    echo "Breezeware Spring Boot conventions active:"
    echo "- Java 21, Maven, Spring Boot"
    echo "- Constructor injection (NEVER @Autowired on fields)"
    echo "- Google Checkstyle (4-space indent, 120 char lines)"
    echo "- Import order: java > javax > org > com > net > lombok"
    echo "- REST API: /api/v1/ prefix, response envelope pattern"
    echo "- Flyway migrations: V{timestamp}__{description}.sql"
    echo ""
    echo "Available: /breezeware-spring-boot:spring-boot-backend, /breezeware-spring-boot:code-review-backend"
fi
