<?php

namespace App\Services;

use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;

class TextToSpeechService
{
    public function convertTextToSpeech(string $text): string
    {
        $apiKey = config('services.voicerss.api_key');

        if (!$apiKey) {
            throw new \Exception('Chave da API VoiceRSS não configurada.');
        }

        // Chamada à API do VoiceRSS (ou similar)
        $response = Http::get('https://api.voicerss.org/', [
            'key' => $apiKey,
            'hl'  => 'pt-br',    // idioma português Brasil
            'src' => $text,      // texto
            'c'   => 'MP3',      // formato
            'f'   => '44khz_16bit_stereo', // qualidade
        ]);

        if ($response->failed()) {
            throw new \Exception('Erro ao se comunicar com a API de TTS.');
        }

        // A API retorna o áudio binário diretamente
        $audioBinary = $response->body();

        // Gera um nome de arquivo único
        $fileName = 'tts/' . Str::uuid() . '.mp3';

        // Salva em storage/app/public/tts
        Storage::disk('public')->put($fileName, $audioBinary);

        // Retorna o caminho que o navegador consegue acessar
        return 'storage/' . $fileName;
    }
}
