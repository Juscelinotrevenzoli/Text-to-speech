<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>Text-to-Speech - Teste Laravel</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body class="bg-light">
<div class="container py-5">
    <h1 class="mb-4">Text-to-Speech Demo</h1>
    <p class="text-muted">
        Digite um texto abaixo e envie. Neste primeiro momento, vamos apenas exibir o texto de volta.
        Depois vamos integrar com a API de voz. 🔊
    </p>

    <div class="card shadow-sm">
        <div class="card-body">
            <form action="{{ route('tts.speak') }}" method="POST">
                @csrf

                <div class="mb-3">
                    <label for="text" class="form-label">Texto para conversão:</label>
                    <textarea
                        name="text"
                        id="text"
                        rows="4"
                        class="form-control @error('text') is-invalid @enderror"
                        required
                    >{{ old('text', $text ?? '') }}</textarea>

                    @error('text')
                    <div class="invalid-feedback">{{ $message }}</div>
                    @enderror
                </div>

                <button type="submit" class="btn btn-primary">
                    Enviar texto
                </button>
            </form>
        </div>
    </div>

        @isset($text)
        <div class="card mt-4">
            <div class="card-body">
                <h5>Texto recebido:</h5>
                <p>{{ $text }}</p>

                @isset($audioPath)
                    <hr>
                    <h5>Áudio gerado:</h5>
                    <audio controls>
                        <source src="{{ asset($audioPath) }}" type="audio/mpeg">
                        Seu navegador não suporta o elemento de áudio.
                    </audio>
                @else
                    <p class="text-danger">Não foi possível gerar o áudio.</p>
                @endisset
            </div>
        </div>
    @endisset

</div>
</body>
</html>
