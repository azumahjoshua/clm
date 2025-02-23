<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\User;  
use Faker\Factory as Faker;  

class UserSeeder extends Seeder
{
    public function run()
    {
        $faker = Faker::create();  // Create a Faker instance

        // Generate 10 fake users
        foreach (range(1, 10) as $index) {
            User::create([
                'username' => $faker->userName,  // Generate a fake username
                'first_name' => $faker->firstName,  // Generate a fake first name
                'last_name' => $faker->lastName,  // Generate a fake last name
                'phone' => $faker->phoneNumber,  // Generate a fake phone number
                'email' => $faker->unique()->safeEmail,  // Generate a unique fake email
                'password' => bcrypt('password'),  // Hash a default password, or use bcrypt($faker->password) for a random password
            ]);
        }
    }
}
