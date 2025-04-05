# CLM

Contract Lifecycle Management

## Prerequisites

Ensure you have the following installed:

- Node.js (for the frontend)
- PHP (>=8.1) and Composer (for the backend)
- PostgreSQL (or the database of your choice)
- Git

## Backend Setup (Laravel)

1. **Clone the repository**  

   ```bash
   git clone https://github.com/azumahjoshua/clm.git
   cd clm
   cd /backend
   ```

2. **Install dependencies**

    ```bash
    composer install
    ```

3. **Set up environment variables**

    Create a **.env** file in the root of backend:

    ```bash
    touch .env
    ```

    Update the **.env** file with your database credentials:\

    ```ini
    DB_CONNECTION=pgsql
    DB_HOST=127.0.0.1
    DB_PORT=5432
    DB_DATABASE=clm
    DB_USERNAME=postgres
    DB_PASSWORD=yourpassword

    ```

4. **Generate application key**

    ```bash
    php artisan key:generate
    ```

5. **Run database migrations and seeders**

    ```bash
    php artisan migrate --seed
    ```

6. **Start the Laravel backend server**

    ```bash
    php artisan serve
    ```

The backend will be available at **http://127.0.0.1:8000**.

## Frontend Setup (Next.js)

1. Navigate to the frontend directory

    ```bash
    cd /frontend
    ```

2. Install dependencies

    ```bash
    npm install
    ```

3. Set up environment variables and Create a .env file then update the **BACKEND_API_HOST** with the backend url:

    ```bash
    BACKEND_API_HOST=http://127.0.0.1:8000
    ```

4. Start the Next.js development server

    ```bash
    npm run dev
    ```

The frontend will be available at **http://localhost:3000**

# Dockerize Both Backend and Frontend

<!-- git checkout -b ansible-setup
git add ansible/
git commit -m "Initialize Ansible setup"
git push origin ansible-setup

git checkout -b fullstack-dev
git add back-end/
git commit -m "Initialize backend development"
git push origin fullstack-dev

git checkout -b  fullstack-dev
git add front-end/
git commit -m "Initialize frontend development"
git push origin  fullstack-dev

git checkout -b terraform-infra
git add terraform/
git commit -m "Initialize Terraform infrastructure"
git push origin terraform-infra

git checkout -b deployment-scripts
git add deploy.sh push-to-ecr.sh set_env.sh
git commit -m "Initialize deployment scripts"
git push origin deployment-scripts

git checkout -b nginx-config
git add nginx/
git commit -m "Initialize Nginx configuration"
git push origin nginx-config

git checkout -b jenkins-pipeline
git add Jenkinsfile Jenkinsfile_old
git commit -m "Initialize Jenkins pipeline"
git push origin jenkins-pipeline -->

