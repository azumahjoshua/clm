<?php

namespace Tests\Feature;

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Foundation\Testing\WithFaker;
use Illuminate\Http\Response;
use Tests\AuthTestCase;
use Faker\Factory as Faker;  

class UserAPITest extends AuthTestCase
{
    use RefreshDatabase, WithFaker;

    public function test_can_retrieve_all_users_list()
    {
        // Seed the database with 11 users
        User::factory()->count(10)->create();

        $response = $this->getJson('/api/admin/users');

        $response->assertStatus(200);
        $this->assertCount(11, $response->decodeResponseJson()['data']);
    }

    public function test_can_register_user()
    {
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
        $faker = Faker::create(); 
        $user = User::factory()->create();
        $seed_data = $user->toArray();

        $updates = [
            'phone' =>'+1'.$faker->numerify('##########'),
        ];
        $seed_data = array_merge($updates, $seed_data);

        $response = $this->patchJson('/api/admin/users/' . $user->id, $seed_data);

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
        $user = User::factory()->create();

        $response = $this->deleteJson('/api/admin/users/' . $user->id);
        $response->assertStatus(Response::HTTP_NO_CONTENT);
    }

    public function test_can_reject_invalid_user_registration()
    {
        $seed_data = User::factory()->make()->toArray();
        $seed_data['password'] = bcrypt('password'); // Add the password field
        User::create($seed_data);

        // Try to register a duplicate user
        $response = $this->postJson('/api/admin/users', $seed_data);

        $response->assertStatus(Response::HTTP_UNPROCESSABLE_ENTITY);
    }
}