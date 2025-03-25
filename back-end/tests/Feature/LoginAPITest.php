<?php

namespace Tests\Feature;

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Hash;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

class LoginAPITest extends TestCase
{
    use RefreshDatabase;

    const TEST_USERNAME = 'abanda';
    const TEST_PASSWORD = 'password';
    const NEW_PASSWORD = '12344321';

    public function test_can_login_with_valid_credentials(): void
    {
        User::factory()->create([
            'username' => self::TEST_USERNAME,
            'password' => bcrypt(self::TEST_PASSWORD),
        ]);

        $data = [
            'username' => self::TEST_USERNAME,
            'password' => self::TEST_PASSWORD,
        ];

        $response = $this->postJson("/api/login", $data);

        $response->assertOk();

        $data = $response->getData();

        $this->assertNotNull($data->api_token);
        $this->assertNotNull($data->user);
    }

    public function test_can_reject_invalid_credentials()
    {
        User::factory()->create(['username' => self::TEST_USERNAME]);

        $data = [
            'username' => "invalid_username",
            'password' => "invalid_password",
        ];

        $response = $this->postJson("/api/login", $data);
        $response->assertUnprocessable();
    }

    public function test_user_can_logout()
    {
        $user = User::factory()->create(['username' => self::TEST_USERNAME]);

        $data = [
            'username' => self::TEST_USERNAME,
            'password' => self::TEST_PASSWORD,
        ];

        $response = $this->postJson("/api/login", $data);
        $response->assertOk();

        $response = $this->withHeaders([
            "Authorization" => "Bearer {$response->decodeResponseJson()['api_token']}"
        ])->postJson("/api/logout");

        $response->assertOk();

        $user->refresh();
        $this->assertEquals(0, $user->tokens()->count());
    }

    public function test_can_change_password()
    {
        $user = User::factory()->create(['username' => self::TEST_USERNAME]);

        $data = [
            'password' => self::NEW_PASSWORD,
            'password_confirmation' => self::NEW_PASSWORD,
        ];

        Sanctum::actingAs($user);
        $response = $this->patchJson("api/users/{$user->id}/change-password", $data);

        $response->assertOk();

        // Verify the password was updated in the database
        $this->assertTrue(Hash::check(self::NEW_PASSWORD, $user->fresh()->password));

        // Try to login with the new password
        $data = [
            'username' => self::TEST_USERNAME,
            'password' => self::NEW_PASSWORD,
        ];

        $response = $this->postJson("/api/login", $data);
        $response->assertOk();
    }
}