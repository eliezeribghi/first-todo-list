<?php

namespace App\Http\Controllers;

use App\Models\Tasks;
use Illuminate\Http\Request;
use Illuminate\Validation\ValidationException;

class TaskController extends Controller
{
    public function list()
    {

        $tasks = Tasks::all();
        foreach($tasks as $task) {
            $task->category;
        }

        return $tasks;
    }

    public function create(Request $request)
    {
        try {

            $validated = $request->validate([
                'title' => 'required|unique:tasks'
            ]);
        } catch (ValidationException $error) {
            return $error;
        }

        $task = new Tasks();
        $task->title = $request->input('title');
        $task->save();

        return $task;
    }

    public function delete($id)
    {
        $task = Tasks::findOrFail($id);
        $task->delete();
        return 'ok';
    }
    public function update(Request $request, $id)
    {
        $task = Tasks::findOrFail($id);
        $task->title = $request->input('title');
        $task->save();
    }
    public function show($id)
    {
        $tasks = Tasks::findOrFail($id);
        $tasks->category;

        // $tasks = Tasks::where('id', '=', $id)->with('category')->get();
        return $tasks;
    }
}
