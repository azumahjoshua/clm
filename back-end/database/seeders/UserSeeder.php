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
                'username' => $faker->userName,  
                'first_name' => $faker->firstName,  
                'last_name' => $faker->lastName,  
                'phone' =>'+1'.$faker->numerify('##########'),  
                'email' => $faker->unique()->safeEmail,  
                'password' => bcrypt('password'), 
            ]);
        }
    }
}
