<?php

namespace Tests\Feature;

use App\Models\Tasks;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class TaskTest extends TestCase
{
    use RefreshDatabase; // Réinitialise la base de données pour chaque test

    public function test_can_list_tasks()
    {
        Tasks::factory()->create(['title' => 'Acheter une salade', 'status' => 0]);
        Tasks::factory()->create(['title' => 'Manger la salade', 'status' => 0]);

        $response = $this->get('/api/tasks');

        $response->assertStatus(200);
        $response->assertJsonCount(2);
        $response->assertJsonFragment(['title' => 'Acheter une salade']);
        $response->assertJsonFragment(['title' => 'Manger la salade']);
    }

    public function test_can_create_task()
    {
        $response = $this->postJson('/api/task', [
            'title' => 'Nouvelle tâche',
            'status' => 0,
        ]);

        $response->assertStatus(200);
        $this->assertDatabaseHas('tasks', [
            'title' => 'Nouvelle tâche',
            'status' => 0,
        ]);
    }

    public function test_create_task_fails_without_title()
    {
        $response = $this->postJson('/api/task', [
            'status' => 0,
        ]);

        $response->assertStatus(422);
        $response->assertJsonValidationErrors('title');
        $this->assertDatabaseMissing('tasks', ['status' => 0]);
    }

    public function test_can_update_task()
    {
        $task = Tasks::factory()->create(['title' => 'Tâche à mettre à jour', 'status' => 0]);

        $response = $this->putJson("/api/task/{$task->id}", [
            'title' => 'Tâche modifiée',
        ]);

        $response->assertStatus(200);
        $this->assertDatabaseHas('tasks', [
            'id' => $task->id,
            'title' => 'Tâche modifiée',
        ]);
    }

    public function test_update_task_fails_without_title()
    {
        $task = Tasks::factory()->create(['title' => 'Tâche à mettre à jour', 'status' => 0]);

        $response = $this->putJson("/api/task/{$task->id}", [
            'title' => '',
        ]);

        $response->assertStatus(422);
        $response->assertJsonValidationErrors('title');
    }

    public function test_can_delete_task()
    {
        $task = Tasks::factory()->create(['title' => 'Tâche à supprimer', 'status' => 0]);

        $response = $this->delete("/api/tasks/{$task->id}");

        $response->assertStatus(200);
        $response->assertSee('ok');
        $this->assertDatabaseMissing('tasks', ['id' => $task->id]);
    }

    public function test_can_show_task()
    {
        $task = Tasks::factory()->create(['title' => 'Tâche à afficher', 'status' => 0]);

        $response = $this->get("/api/task/{$task->id}");

        $response->assertStatus(200);
        $response->assertJsonFragment(['title' => 'Tâche à afficher']);
    }

    public function test_show_task_fails_for_nonexistent_id()
    {
        $response = $this->get('/api/task/999');

        $response->assertStatus(404);
    }
}
