<?php
// --- CONFIGURAÇÕES DO SERVIDOR ---
$mail_host = 'servidor_email'; 
$usuario   = 'aluno';          
$senha     = '123456';         
$dominio   = 'provedor.asa.br'; 

// --- LÓGICA DE ENVIO ---
$status_envio = "";
if (isset($_POST['btn_enviar'])) {
    $para     = $_POST['para'];
    $assunto  = $_POST['assunto'];
    $mensagem = $_POST['mensagem'];
    $headers  = "From: $usuario@$dominio" . "\r\n" .
                "Reply-To: $usuario@$dominio" . "\r\n" .
                "X-Mailer: PHP/" . phpversion();

    if(@mail($para, $assunto, $mensagem, $headers)) {
        $status_envio = "<b style='color:green'>E-mail enviado com sucesso!</b>";
    } else {
        $status_envio = "<b style='color:red'>Erro no envio (Postfix).</b>";
    }
}

// --- LÓGICA DE RECEBIMENTO (IMAP) ---
$servidor = "{" . $mail_host . ":143/imap/notls/novalidate-cert}INBOX";
// Tentativa de conexão
$mbox = @imap_open($servidor, $usuario, $senha);
$erro_imap = imap_last_error(); // Captura o erro se houver
?>

<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <title>Webmail ASA</title>
    <style>
        body { font-family: sans-serif; margin: 20px; background: #f4f4f4; }
        .container { background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .box-envio { background: #e9ecef; padding: 15px; border-radius: 5px; margin-bottom: 20px; }
        input, textarea { width: 100%; padding: 8px; margin: 5px 0; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box; }
        button { background: #007bff; color: white; border: none; padding: 10px 20px; cursor: pointer; border-radius: 4px; }
        .mensagem { border-bottom: 1px solid #eee; padding: 10px 0; }
    </style>
</head>
<body>
    <div class="container">
        <h1>Webmail ASA - Logado como <?php echo $usuario; ?></h1>
        
        <div class="box-envio">
            <h3>Nova Mensagem</h3>
            <?php echo $status_envio; ?>
            <form method="post">
                <input type="email" name="para" placeholder="Para: destinatario@dominio.com" required>
                <input type="text" name="assunto" placeholder="Assunto" required>
                <textarea name="mensagem" rows="4" placeholder="Escreva aqui..." required></textarea>
                <button type="submit" name="btn_enviar">Enviar E-mail</button>
            </form>
        </div>

        <hr>

        <h3>Caixa de Entrada (INBOX)</h3>
        <?php
        if ($mbox) {
            $total = imap_num_msg($mbox);
            echo "<p>Total de mensagens: <b>$total</b></p>";
            for ($i = $total; $i > 0; $i--) {
                $header = imap_headerinfo($mbox, $i);
                $corpo = imap_fetchbody($mbox, $i, 1);
                echo "<div class='mensagem'>";
                echo "<b>De:</b> " . ($header->fromaddress) . "<br>";
                echo "<b>Assunto:</b> " . ($header->subject) . "<br>";
                echo "<b>Conteúdo:</b> " . nl2br(htmlspecialchars($corpo)) . "<br>";
                echo "</div>";
            }
            imap_close($mbox);
        } else {
            echo "<p style='color:red'>Erro ao conectar: " . $erro_imap . "</p>";
        }
        ?>
    </div>
</body>
</html>