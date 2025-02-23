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