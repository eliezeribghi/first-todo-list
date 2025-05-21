<?php

namespace Tests\Feature;

use App\Models\Tasks;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class TaskControllerTest extends TestCase
{
    use RefreshDatabase;

    /**
     * Test updating a task's status.
     *
     * @return void
     */
    public function test_update_task_status()
    {
        $task = Tasks::factory()->create(['title' => 'Tâche à mettre à jour', 'status' => 0]);

        $response = $this->putJson("/api/task/{$task->id}", [
            'title' => 'Tâche à mettre à jour',
            'status' => 1,
        ]);

        $response->assertStatus(200);
        $this->assertDatabaseHas('tasks', [
            'id' => $task->id,
            'status' => 1,
        ]);
    }
}
