<?php


namespace Tests\Unit;

use App\Models\Tasks;
use PHPUnit\Framework\TestCase;

class TaskTest extends TestCase
{
    public function test_task_is_completed_based_on_status()
    {
        // Créer une tâche sans interagir avec la base de données
        $task = new Tasks(['title' => 'Test Task', 'status' => 1]);

        // Tester une méthode hypothétique isCompleted
        $this->assertTrue($task->isCompleted());

        // Changer le statut
        $task->status = 0;
        $this->assertFalse($task->isCompleted());
    }
}
