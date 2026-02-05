<?php
// Configurações de conexão
$servidor = "{localhost:143/imap/notls}INBOX";
$usuario  = "teste@mymail.com.br";
$senha    = "sua_senha";

// Conecta à caixa de e-mail
$mbox = imap_open($servidor, $usuario, $senha) 
        or die("Erro ao conectar: " . imap_last_error());

// Obtém o número total de mensagens
$total = imap_num_msg($mbox);

echo "<h2>Meu Webmail Caseiro</h2>";
echo "Total de mensagens: " . $total . "<br><hr>";

// Lista as últimas 10 mensagens
for ($i = $total; $i > 0 && $i > ($total - 10); $i--) {
    $header = imap_headerinfo($mbox, $i);
    $subject = $header->subject;
    $from = $header->fromaddress;
    $date = $header->date;

    echo "<b>De:</b> $from <br>";
    echo "<b>Assunto:</b> <a href='ver.php?id=$i'>$subject</a> <br>";
    echo "<b>Data:</b> $date <br><hr>";
}

imap_close($mbox);
?>