<?php

namespace Tests\Feature;

use App\Models\Tasks;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class TaskTest extends TestCase
{
    use RefreshDatabase; // Resets the database for each test

    /**
     * Test listing all tasks.
     *
     * @return void
     */
    public function test_can_list_tasks()
    {
        Tasks::factory()->create(['title' => 'Acheter une salade', 'status' => 0]);
        Tasks::factory()->create(['title' => 'Manger la salade', 'status' => 0]);

        $response = $this->getJson('/api/tasks');

        $response->assertStatus(200);
        $response->assertJsonCount(2);
        $response->assertJsonFragment(['title' => 'Acheter une salade']);
        $response->assertJsonFragment(['title' => 'Manger la salade']);
    }

    /**
     * Test creating a task.
     *
     * @return void
     */
    public function test_can_create_task()
    {
        $response = $this->postJson('/api/task', [
            'title' => 'Nouvelle tâche',
            'status' => 0,
        ]);

        $response->assertStatus(200); // TaskController returns the created task
        $this->assertDatabaseHas('tasks', [
            'title' => 'Nouvelle tâche',
            'status' => 0,
        ]);
    }

    /**
     * Test creating a task fails without a title.
     *
     * @return void
     */
    public function test_create_task_fails_without_title()
    {
        $response = $this->postJson('/api/task', [
            'status' => 0,
        ]);

        $response->assertStatus(422);
        $response->assertJsonValidationErrors('title');
        $this->assertDatabaseMissing('tasks', ['status' => 0]);
    }

    /**
     * Test updating a task.
     *
     * @return void
     */
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

    /**
     * Test updating a task fails without a title.
     *
     * @return void
     */
    public function test_update_task_fails_without_title()
    {
        $task = Tasks::factory()->create(['title' => 'Tâche à mettre à jour', 'status' => 0]);

        $response = $this->putJson("/api/task/{$task->id}", [
            'title' => '',
        ]);

        $response->assertStatus(422);
        $response->assertJsonValidationErrors('title');
    }

    /**
     * Test deleting a task.
     *
     * @return void
     */
    public function test_can_delete_task()
    {
        $task = Tasks::factory()->create(['title' => 'Tâche à supprimer', 'status' => 0]);

        $response = $this->deleteJson("/api/tasks/{$task->id}");

        $response->assertStatus(200);
        $response->assertSee('ok');
        $this->assertDatabaseMissing('tasks', ['id' => $task->id]);
    }

    /**
     * Test showing a task.
     *
     * @return void
     */
    public function test_can_show_task()
    {
        $task = Tasks::factory()->create(['title' => 'Tâche à afficher', 'status' => 0]);

        $response = $this->getJson("/api/task/{$task->id}");

        $response->assertStatus(200);
        $response->assertJsonFragment(['title' => 'Tâche à afficher']);
    }

    /**
     * Test showing a task fails for a nonexistent ID.
     *
     * @return void
     */
    public function test_show_task_fails_for_nonexistent_id()
    {
        $response = $this->getJson('/api/task/999');

        $response->assertStatus(404);
    }
}
