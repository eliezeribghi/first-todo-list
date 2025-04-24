<?php

use App\Http\Controllers\CategoryController;
use App\Http\Controllers\TagController;
use App\Http\Controllers\TaskController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});

// ---------------Task------------------------------

Route::get('/task', [TaskController::class, 'list']);
Route::post('/task', [TaskController::class, 'create']);
Route::delete('/tasks/{id}', [TaskController::class, 'delete']);
Route::put('/task/{id}', [TaskController::class, 'update']);
Route::get('/task/{id}', [TaskController::class, 'show']);
Route::get('/tasks', [TaskController::class, 'list']);
// -----------------Categories----------------------

Route::get('/categories', [CategoryController::class, 'list']);
Route::post('/category', [CategoryController::class, 'create']);
Route::delete('/categorys/{id}', [CategoryController::class, 'delete']);
Route::put('/category/{id}', [CategoryController::class, 'update']);
Route::get('/category/{id}', [CategoryController::class, 'show']);

// -----------------Tag----------------------

Route::get('/tags', [TagController::class, 'list']);
Route::post('/tag', [TagController::class, 'create']);
Route::delete('/tags/{id}', [TagController::class, 'delete']);
Route::put('/tag/{id}', [TagController::class, 'update']);
Route::get('/tag/{id}', [TagController::class, 'show']);
