# Návod pre nasadenie aplikácie
Aplikácia je nasadená na Azure Web app, kde beží frontend (FE) aj backend (BE).

## Nasadenie BE
### 1. Build aplikácie
Aplikáciu skompilujeme pomocou príkazu:
`mvn clean install`

### 2. Build docker image
V termináli musíme byť v zložke BE.

#### 1. Build pomocou systému s architektúrou x86
1. Image skompilujeme pomocou príkazu:  
   `docker build . -t groben5558/alfri:alfri-backend`

2. Image pushneme do Docker Hub repozitára pomocou príkazu:  
   `docker push groben5558/alfri:alfri-backend`

#### 2. Build pomocou systému s architektúrou ARM
1. Image skompilujeme a pushneme do Docker Hub repozitára pomocou príkazu:  
   `docker buildx build --platform linux/amd64 -t groben5558/alfri:alfri-backend -f Dockerfile . --push`

## Nasadenie FE
### 1. Build aplikácie
Aplikáciu skompilujeme pomocou príkazu:  
`npm run build`

### 2. Build docker image
V termináli musíme byť v zložke FE.

#### 1. Build pomocou systému s architektúrou x86
1. Image skompilujeme pomocou príkazu:  
   `docker build . -t groben5558/alfri:alfri-frontend`

2. Image pushneme do Docker Hub repozitára pomocou príkazu:  
   `docker push groben5558/alfri:alfri-frontend`

#### 2. Build pomocou systému s architektúrou ARM
1. Image skompilujeme a pushneme do Docker Hub repozitára pomocou príkazu:  
   `docker buildx build --platform linux/amd64 -t groben5558/alfri:alfri-frontend -f Dockerfile . --push`

## Po uploadnutí nových imagov je potrebné reštartovať Azure Web app
Aplikácia sa štartuje niekoľko minút kvôli nízkemu hardvéru servera. FE sa spustí takmer hneď, no BE sa púšťa o niekoľko minút neskôr. Ak je BE spustený, jeho logy vidíme v `Log stream` alebo v sekcii `Monitoring/Health-check/Instances`, kde aplikáciu vidíme ako "healthy".

# Prvé nasadenie aplikácie
Je potrebné vytvoriť Azure Web app.

1. V sekcii **Publish** nastaviť *Container*.
2. **Operating system** je *Linux*.
3. **Region** je *West Europe*.

V sekcii **Container** je potrebné nastaviť:
1. **Image source** - Docker Hub or other registries
2. **Options** - docker compose

V sekcii **Docker Hub options**:
1. **Public**
2. **Configuration file** - uploadnúť docker.compose súbor z projektu

Vytvoriť.

Po vytvorení Web app:
1. Sekcia **Settings/Environment variables** - nastaviť hodnoty environment variables pre beh BE:
   - `APPLICATION_NAME` - názov BE aplikácie (ľubovoľný)
   - `DATABASE_PROD_PASSWORD` - Heslo od databázy - zadávať bez ''
   - `DATABASE_PROD_URL` - connection string od databázy, napr. `jdbc:postgresql://alfri-database.postgres.database.azure.com:5432/alfri`
   - `DATABASE_PROD_USER` - meno používateľa v databáze pre BE server
   - `FRONTEND_PROD_URL` - URL link na frontend, napr. `alfri-whole-ezhhdydubxf7c9gk.westeurope-01.azurewebsites.net`
   - `JWT_PROD_EXPIRATION_TIME` - čas expirácie JWT tokenu v ms
   - `JWT_PROD_SECRET_KEY` - privátny kľúč pre šifrovanie a podpisovanie JWT kľúčov (64 znakov)
   - `PROD_SHOW_SQL` - bool pre zobrazenie SQL selectov v logoch (TRUE/FALSE)

2. Sekcia **Monitoring/Health-check** - nastaviť health-check aplikácie na `backend/actuator/health`.

Server reštartujeme a čakáme.

URL aplikácie nájdeme v **Overview - Default domain**.
