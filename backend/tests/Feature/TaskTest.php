<?php
namespace Tests\Feature;

use App\Models\Task;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class TaskTest extends TestCase
{
    use RefreshDatabase;

    public function test_can_create_task()
    {
        $response = $this->post('/tasks', [
            'title' => 'Nouvelle tâche',
            'status' => 0,
        ]);

        $response->assertStatus(201);
        $this->assertDatabaseHas('tasks', [
            'title' => 'Nouvelle tâche',
            'status' => 0,
        ]);
    }

    public function test_can_retrieve_tasks()
    {
        Task::factory()->create([
            'title' => 'Tâche existante',
            'status' => 0,
        ]);

        $response = $this->get('/tasks');

        $response->assertStatus(200);
        $response->assertJsonFragment(['title' => 'Tâche existante']);
    }

    public function test_can_update_task_status()
    {
        $task = Task::factory()->create([
            'title' => 'Tâche à mettre à jour',
            'status' => 0,
        ]);

        $response = $this->patch("/tasks/{$task->id}", [
            'status' => 1,
        ]);

        $response->assertStatus(200);
        $this->assertDatabaseHas('tasks', [
            'id' => $task->id,
            'status' => 1,
        ]);
    }

    public function test_can_delete_task()
    {
        $task = Task::factory()->create([
            'title' => 'Tâche à supprimer',
            'status' => 0,
        ]);

        $response = $this->delete("/tasks/{$task->id}");

        $response->assertStatus(204);
        $this->assertDatabaseMissing('tasks', [
            'id' => $task->id,
        ]);
    }

    public function test_task_creation_fails_without_title()
    {
        $response = $this->post('/tasks', [
            'status' => 0,
        ]);

        $response->assertStatus(422);
        $response->assertJsonValidationErrors('title');
    }
}
