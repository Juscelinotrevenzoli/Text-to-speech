<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\TextToSpeechController;

Route::get('/', [TextToSpeechController::class, 'index'])->name('tts.form');
Route::post('/speak', [TextToSpeechController::class, 'speak'])->name('tts.speak');
