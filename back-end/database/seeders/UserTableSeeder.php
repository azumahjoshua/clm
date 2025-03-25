<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Seeder;
use Faker\Factory as Faker;  

class UserTableSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */

    
    public function run(): void
    {
        $user = User::create([
            'username' => "admin",
            'first_name' => "admin",
            'last_name' => "clm",
            'email' => "admin@clms.com",
            'phone' => "1234567890",
            'password' => bcrypt("password")
        ]);
    }
}
