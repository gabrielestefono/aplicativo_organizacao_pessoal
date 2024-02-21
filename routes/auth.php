<?php

use App\Http\Controllers\Controller;
use App\Http\Controllers\ObjetivoController;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/

Route::post('/registrar', [Controller::class, 'registrar'])->name('registrar');
Route::post('/login', [Controller::class, 'login'])->name('login');

Route::get('/objetivo', [ObjetivoController::class, 'index'])->middleware(['auth:sanctum']);
Route::post('/objetivo', [ObjetivoController::class, 'store'])->middleware(['auth:sanctum']);
Route::get('/objetivo/{objetivo}', [ObjetivoController::class, 'show'])->middleware(['auth:sanctum']);
Route::put('/objetivo/{objetivo}', [ObjetivoController::class, 'update'])->middleware(['auth:sanctum']);
Route::delete('/objetivo/{objetivo}', [ObjetivoController::class, 'destroy'])->middleware(['auth:sanctum']);
Route::get('/objetivo-restore/{objetivo}', [ObjetivoController::class, 'restore'])->middleware(['auth:sanctum']);
Route::get('/objetivo-delete/{objetivo}', [ObjetivoController::class, 'forceDelete'])->middleware(['auth:sanctum']);
Route::patch('/objetivo-concluido/{id}', [ObjetivoController::class, 'conclusao'])->middleware(['auth:sanctum']);
Route::patch('/objetivo-arquivado/{id}', [ObjetivoController::class, 'arquivar'])->middleware(['auth:sanctum']);
Route::patch('/objetivo-prioridade/{id}/{n}', [ObjetivoController::class, 'prioridade'])->middleware(['auth:sanctum']);
