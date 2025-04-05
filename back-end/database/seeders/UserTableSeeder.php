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
        $faker = Faker::create(); 
        $user = User::create([
            'username' => "admin",
            'first_name' => "admin",
            'last_name' => "clm",
            'email' => "admin@clms.com",
            'phone' =>'+1'.$faker->numerify('##########'),
            'password' => bcrypt("password")
        ]);
    }
}