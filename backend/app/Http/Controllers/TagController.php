<?php

namespace App\Http\Controllers;

use App\Models\Tag;
use Illuminate\Http\Request;
use Illuminate\Validation\ValidationException;

class TagController extends Controller
{
    public function list()
    {

        return Tag::all();

        
    }

    public function create(Request $request)
    {
        try {

           $request->validate([
                'name' => 'required|unique:tags',
            ]);
        } catch (ValidationException $error) {
            return $error;
        }

        $tag = new Tag;
        $tag->name = $request->input('name');
        $tag->save();

        return $tag;
    }

    public function delete($id)
    {
        $tag = Tag::findOrFail($id);
        $tag->delete();

        return 'ok';
    }

    public function update(Request $request, $id)
    {
        $tag = Tag::findOrFail($id);
        $tag->name = $request->input('name');
        $tag->save();
    }
}
