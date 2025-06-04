<?php

namespace Database\Factories;

use App\Models\Tasks;
use Illuminate\Database\Eloquent\Factories\Factory;

class TasksFactory extends Factory
{
    protected $model = Tasks::class;

    public function definition()
    {
        return [
            'title' => $this->faker->sentence(3),
            'status' => 0,
            'created_at' => now(),
            'updated_at' => now(),
        ];
    }
}
