<?php

namespace Tests\Feature;

use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class TaskTest extends TestCase
{
    use RefreshDatabase; // Réinitialise la base de données pour chaque test

    public function test_can_create_task()
    {
        $response = $this->post('/tasks', [
            'title' => 'Nouvelle tâche',
            'status' => 0,
        ]);

        $response->assertStatus(201); // Vérifie que la tâche est créée
        $this->assertDatabaseHas('tasks', [
            'title' => 'Nouvelle tâche',
            'status' => 0,
        ]);
    }

    public function test_can_retrieve_tasks()
    {
        // Insérer une tâche directement dans la base de données
        \App\Models\Tasks::factory()->create([
            'title' => 'Tâche existante',
            'status' => 0,
        ]);

        $response = $this->get('/tasks');

        $response->assertStatus(200);
        $response->assertJsonFragment(['title' => 'Tâche existante']);
    }
}
