<?php
// Minimal account registration page.
// Creates login-server accounts using the credentials provided by the compose service.

$db_host = getenv('DB_HOST');
$db_name = getenv('DB_NAME');
$db_user = getenv('DB_USER');
$db_pass = getenv('DB_PASS');

function registerAccount(string $db_host, string $db_name, string $db_user, string $db_pass): array
{
    if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
        return ['', false];
    }

    $login    = trim($_POST['login'] ?? '');
    $password = $_POST['password'] ?? '';

    if (strlen($login) < 5 || strlen($login) > 45 || !ctype_alnum(str_replace('_', '', $login))) {
        return ['Username must contain only alphanumeric characters and be 5-45 characters long.', false];
    }

    if (strlen($password) < 8 || strlen($password) > 45) {
        return ['Password must be 8-45 characters long.', false];
    }

    $hash = base64_encode(sha1($password, true));

    try {
        $pdo = new PDO("mysql:host=$db_host;dbname=$db_name;charset=utf8mb4", $db_user, $db_pass);
        $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        $stmt = $pdo->prepare("INSERT INTO accounts (login, password, lastactive, accessLevel) VALUES (?, ?, ?, 0)");
        $stmt->execute([$login, $hash, round(microtime(true) * 1000)]);

        return ["Account $login created successfully.", true];
    } catch (PDOException $e) {
        return [$e->getCode() == 23000 ? 'Username already taken.' : 'Database error. Try again later.', false];
    }
}

[$msg, $ok] = registerAccount($db_host, $db_name, $db_user, $db_pass);
?><!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Register Account</title>
<style>
  body { font-family: sans-serif; max-width: 360px; margin: 80px auto; padding: 0 1rem; }
  label { display: block; margin: 12px 0 4px; }
  input { width: 100%; padding: 8px; box-sizing: border-box; }
  button { margin-top: 16px; padding: 8px 20px; cursor: pointer; }
  .ok  { color: green; margin-top: 1rem; }
  .err { color: red;   margin-top: 1rem; }
</style>
</head>
<body>
<h2>Register Account</h2>
<form method="POST">
  <label>Username<input name="login" maxlength="45" autocomplete="username" required placeholder="5-45 characters"></label>
  <label>Password<input name="password" type="password" maxlength="45" autocomplete="new-password" required placeholder="8-45 characters"></label>
  <button type="submit">Register</button>
</form>
<?php if ($msg): ?>
  <p class="<?= $ok ? 'ok' : 'err' ?>"><?= htmlspecialchars($msg, ENT_QUOTES, 'UTF-8') ?></p>
<?php endif; ?>
</body>
</html>
