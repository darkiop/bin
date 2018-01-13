<?php
$isg = 'http://isg/?s=0';
$html = file_get_contents($isg);
$erg_ls = preg_match('/=\'val82a.+?jsobj\[\'val\'\]=\'([\d,]+)/s',$html,$matches);
$Luefterstufe = str_replace(',', '.', $matches[1]);
echo $Luefterstufe;
?>