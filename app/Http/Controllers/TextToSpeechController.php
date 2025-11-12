<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Services\TextToSpeechService;

class TextToSpeechController extends Controller
{
    protected $ttsService;

    public function __construct(TextToSpeechService $ttsService)
    {
        $this->ttsService = $ttsService;
    }

    // Mostra o formulário
    public function index()
    {
        return view('tts.form');
    }

    // Recebe o texto e envia para a API de TTS
    public function speak(Request $request)
    {
        $request->validate([
            'text' => 'required|string|max:500',
        ]);

        $text = $request->input('text');

        // Chama o service para gerar o áudio
        // (o método certo é convertTextToSpeech)
        $audioPath = $this->ttsService->convertTextToSpeech($text);

        // Retorna a view com o texto e o caminho do áudio
        return view('tts.form', [
            'text'      => $text,
            'audioPath' => $audioPath,
        ]);
    }
}
