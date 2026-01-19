#!/bin/bash

# ============================================================================
# TEST-SKRIPT FOR OPPGAVE 1: Docker-oppsett og PostgreSQL-tilkobling
# ============================================================================

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DOCKER_COMPOSE_FILE="$SCRIPT_DIR/docker-compose.yml"

# Farger for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}========================================${NC}"
echo -e "${YELLOW}TEST: Oppgave 1 - Docker-oppsett${NC}"
echo -e "${YELLOW}========================================${NC}"

# Test 1: Docker er installert
echo -e "\n${YELLOW}Test 1: Docker er installert${NC}"
if command -v docker &> /dev/null; then
    DOCKER_VERSION=$(docker --version)
    echo -e "${GREEN}✓ Docker funnet: $DOCKER_VERSION${NC}"
else
    echo -e "${RED}✗ Docker ikke funnet. Installer Docker Desktop.${NC}"
    exit 1
fi

# Test 2: docker-compose er installert
echo -e "\n${YELLOW}Test 2: docker-compose er installert${NC}"
if command -v docker-compose &> /dev/null; then
    DC_VERSION=$(docker-compose --version)
    echo -e "${GREEN}✓ docker-compose funnet: $DC_VERSION${NC}"
else
    echo -e "${RED}✗ docker-compose ikke funnet.${NC}"
    exit 1
fi

# Test 3: docker-compose.yml eksisterer
echo -e "\n${YELLOW}Test 3: docker-compose.yml eksisterer${NC}"
if [ -f "$DOCKER_COMPOSE_FILE" ]; then
    echo -e "${GREEN}✓ docker-compose.yml funnet${NC}"
else
    echo -e "${RED}✗ docker-compose.yml ikke funnet${NC}"
    exit 1
fi

# Test 4: Start PostgreSQL
echo -e "\n${YELLOW}Test 4: Start PostgreSQL med docker-compose${NC}"
cd "$SCRIPT_DIR"
docker-compose up -d
sleep 5

# Test 5: Verifiser at container kjører
echo -e "\n${YELLOW}Test 5: Verifiser at PostgreSQL-container kjører${NC}"
if docker-compose ps | grep -q "data1500-postgres.*Up"; then
    echo -e "${GREEN}✓ PostgreSQL-container kjører${NC}"
else
    echo -e "${RED}✗ PostgreSQL-container kjører ikke${NC}"
    docker-compose logs
    exit 1
fi

# Test 6: Verifiser database-tilkobling (kjør inne i container)
echo -e "\n${YELLOW}Test 6: Verifiser database-tilkobling${NC}"
if docker-compose exec -T postgres psql -U admin -d data1500_db -c "SELECT 1" &> /dev/null; then
    echo -e "${GREEN}✓ Tilkobling til PostgreSQL vellykket${NC}"
else
    echo -e "${RED}✗ Kunne ikke koble til PostgreSQL${NC}"
    echo -e "${YELLOW}Debugging info:${NC}"
    docker-compose logs postgres || true
    exit 1
fi

# Test 7: Verifiser at tabeller eksisterer
echo -e "\n${YELLOW}Test 7: Verifiser at tabeller eksisterer${NC}"
TABLES=$(docker-compose exec -T postgres psql -U admin -d data1500_db -t -c "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema='public'")
TABLES=$(echo "$TABLES" | tr -d ' ')
if [ "$TABLES" -gt 0 ]; then
    echo -e "${GREEN}✓ Tabeller funnet: $TABLES${NC}"
else
    echo -e "${RED}✗ Ingen tabeller funnet${NC}"
    exit 1
fi

# Test 8: Verifiser testdata
echo -e "\n${YELLOW}Test 8: Verifiser testdata${NC}"
STUDENT_COUNT=$(docker-compose exec -T postgres psql -U admin -d data1500_db -t -c "SELECT COUNT(*) FROM studenter" | tr -d ' ')
PROGRAM_COUNT=$(docker-compose exec -T postgres psql -U admin -d data1500_db -t -c "SELECT COUNT(*) FROM programmer" | tr -d ' ')
EMNE_COUNT=$(docker-compose exec -T postgres psql -U admin -d data1500_db -t -c "SELECT COUNT(*) FROM emner" | tr -d ' ')

if [ "$STUDENT_COUNT" -gt 0 ] && [ "$PROGRAM_COUNT" -gt 0 ] && [ "$EMNE_COUNT" -gt 0 ]; then
    echo -e "${GREEN}✓ Testdata lastet inn${NC}"
    echo -e "  - Studenter: $STUDENT_COUNT"
    echo -e "  - Programmer: $PROGRAM_COUNT"
    echo -e "  - Emner: $EMNE_COUNT"
else
    echo -e "${RED}✗ Testdata ikke lastet inn${NC}"
    exit 1
fi

# Test 9: Verifiser roller
echo -e "\n${YELLOW}Test 9: Verifiser roller${NC}"
ROLES=$(docker-compose exec -T postgres psql -U admin -d data1500_db -t -c "SELECT COUNT(*) FROM pg_roles WHERE rolname IN ('admin_role', 'foreleser_role', 'student_role')" | tr -d ' ')
if [ "$ROLES" -eq 3 ]; then
    echo -e "${GREEN}✓ Alle roller opprettet${NC}"
else
    echo -e "${RED}✗ Ikke alle roller funnet (funnet: $ROLES)${NC}"
    exit 1
fi

# Test 10: Verifiser at foreleser kan koble til
echo -e "\n${YELLOW}Test 10: Verifiser at foreleser_role kan koble til${NC}"
if docker-compose exec -T postgres psql -U foreleser_role -d data1500_db -c "SELECT 1" &> /dev/null; then
    echo -e "${GREEN}✓ foreleser_role kan koble til${NC}"
else
    echo -e "${RED}✗ foreleser_role kan ikke koble til${NC}"
    exit 1
fi

# Test 11: Verifiser at student kan koble til
echo -e "\n${YELLOW}Test 11: Verifiser at student_role kan koble til${NC}"
if docker-compose exec -T postgres psql -U student_role -d data1500_db -c "SELECT 1" &> /dev/null; then
    echo -e "${GREEN}✓ student_role kan koble til${NC}"
else
    echo -e "${RED}✗ student_role kan ikke koble til${NC}"
    exit 1
fi

echo -e "\n${GREEN}========================================${NC}"
echo -e "${GREEN}✓ ALLE TESTER BESTÅTT!${NC}"
echo -e "${GREEN}========================================${NC}"

# Cleanup
echo -e "\n${YELLOW}Stopper PostgreSQL...${NC}"
docker-compose down
echo -e "${GREEN}✓ PostgreSQL stoppet${NC}"
