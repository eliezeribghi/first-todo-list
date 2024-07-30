<?php

namespace App\Http\Controllers;

use App\Models\Category;
use Illuminate\Http\Request;
use Illuminate\Validation\ValidationException;

class CategoryController extends Controller
{
    public function list()
    {

        $categories = Category::all();
        return $categories;
    }

    public function create(Request $request)
    {
        try {

            $validated = $request->validate([
                'title' => 'required|unique:categories'
            ]);
        } catch (ValidationException $error) {
            return $error;
        }

        $category = new Category();
        $category->title = $request->input('title');
        $category->save();

        return $category;
    }

    public function delete($id)
    {
        $category = Category::findOrFail($id);
        $category->delete();
        return 'ok';
    }
    public function update(Request $request, $id)
    {
        $category = Category::findOrFail($id);
        $category->title = $request->input('title');
        $category->save();
    }

    public function show($id)
    {
        $category = Category::findOrFail($id);
        $category->tasks;

        return $category;
    }
    
}
