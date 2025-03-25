<?php

namespace Tests\Feature;

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Foundation\Testing\WithFaker;
use Illuminate\Http\Response;
use Tests\AuthTestCase;
use Database\Seeders\UserSeeder; // Import the UserSeeder

class UserAPITest extends AuthTestCase
{
    use RefreshDatabase, WithFaker;

    public function test_can_retrieve_all_users_list()
    {
        // Seed the database using the UserSeeder
        $this->seed(UserSeeder::class);

        // Create an additional user to make the total 11
        User::factory()->create();

        $response = $this->getJson('/api/admin/users');

        $response->assertStatus(200);
        $this->assertCount(12, $response->decodeResponseJson()['data']);
    }

    public function test_can_register_user()
    {
        // Seed the database using the UserSeeder
        $this->seed(UserSeeder::class);

        // Create a new user using the factory (for registration test)
        $seed_data = User::factory()->make()->toArray();
        $seed_data['password'] = 'password'; // Add the password field
        $seed_data['password_confirmation'] = 'password'; // Add password confirmation

        $response = $this->postJson('/api/admin/users', $seed_data);
        $response->assertStatus(Response::HTTP_CREATED);

        $user = User::where('username', $seed_data['username'])->first();
        $this->assertNotNull($user);
    }

    public function test_can_update_user_details()
    {
        // Seed the database using the UserSeeder
        $this->seed(UserSeeder::class);

        // Get the first user from the seeded data
        $user = User::first();

        $updates = [
            'phone' => '9874561230', // Update the phone number
        ];

        $response = $this->patchJson('/api/admin/users/' . $user->id, $updates);

        // Assert the response status code
        $response->assertStatus(200);

        // Assert the user's details were updated in the database
        $this->assertDatabaseHas('users', [
            'id' => $user->id,
            'phone' => $updates['phone'],
        ]);
    }

    public function test_can_delete_user()
    {
        // Seed the database using the UserSeeder
        $this->seed(UserSeeder::class);

        // Get the first user from the seeded data
        $user = User::first();

        $response = $this->deleteJson('/api/admin/users/' . $user->id);
        $response->assertStatus(Response::HTTP_NO_CONTENT);

        // Assert the user was deleted
        $this->assertDatabaseMissing('users', [
            'id' => $user->id,
        ]);
    }

    public function test_can_reject_invalid_user_registration()
    {
        // Seed the database using the UserSeeder
        $this->seed(UserSeeder::class);

        // Get the first user from the seeded data
        $user = User::first();

        // Try to register a duplicate user
        $response = $this->postJson('/api/admin/users', [
            'username' => $user->username, // Duplicate username
            'email' => $user->email, // Duplicate email
            'password' => 'password',
            'password_confirmation' => 'password',
        ]);

        $response->assertStatus(Response::HTTP_UNPROCESSABLE_ENTITY);
    }
}