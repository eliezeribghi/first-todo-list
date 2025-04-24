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
        foreach ($tasks as $task) {
            $task->category;
        }

        return $tasks;
    }

    public function create(Request $request)
    {
        try {

             $request->validate([
                'title' => 'required|string|max:255',
            ]);
        } catch (ValidationException $error) {
            return $error;
        }

        $task = new Tasks;
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
        try {
            // Validation des données
            $request->validate([
                'title' => 'required|string|max:255',
            ]);

            // Trouver la tâche à mettre à jour
            $task = Tasks::findOrFail($id);

            // Mettre à jour la tâche
            $task->title = $request->input('title');
            $task->save();

            // Retourner la tâche mise à jour
            return response()->json($task, 200);
        } catch (ValidationException $error) {
            // Retourner l'erreur de validation au format JSON
            return response()->json([
                'message' => 'Validation Error',
                'errors' => $error->errors(),
            ], 422);
        } catch (\Exception $e) {
            // Retourner une erreur générique pour d'autres exceptions
            return response()->json([
                'message' => 'An error occurred',
                'error' => $e->getMessage(),
            ], 500);
        }
    }

    public function show($id)
    {
        $tasks = Tasks::findOrFail($id);
        $tasks->category;

        // $tasks = Tasks::where('id', '=', $id)->with('category')->get();
        return $tasks;
    }
}
