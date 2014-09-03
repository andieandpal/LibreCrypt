unit HashAlgTigerSBoxes_U;
// Description: Tiger SBoxes
// By Sarah Dean
// Email: sdean12@sdean12.org
// WWW:   http://www.SDean12.org/
//
// -----------------------------------------------------------------------------
//


// !! WARNING !!
// Because Delphi doesn't support an UNSIGNED int64 datatype, this software
// uses LONGLONGs - a SIGNED datatype.
// This means that this software can only be used to hash strings, etc which
// are up to $7FFFFFFFFFFFFFF bytes in length (576460752303423487 bytes; or
// 536870911 GB - which should be enough for most people!)
// See "[*1]" in code below

interface

uses
  Windows, SDUGeneral;  // Required for LONGLONG

  
// Ported from sboxes.c (Tiger reference implementation)
const tigerTable: array [0..((4*256)-1)] of ULONGLONG = (
    $02AAB17CF7E90C5E   {    0 },    $AC424B03E243A8EC   {    1 },
    $72CD5BE30DD5FCD3   {    2 },    $6D019B93F6F97F3A   {    3 },
    $CD9978FFD21F9193   {    4 },    $7573A1C9708029E2   {    5 },
    $B164326B922A83C3   {    6 },    $46883EEE04915870   {    7 },
    $EAACE3057103ECE6   {    8 },    $C54169B808A3535C   {    9 },
    $4CE754918DDEC47C   {   10 },    $0AA2F4DFDC0DF40C   {   11 },
    $10B76F18A74DBEFA   {   12 },    $C6CCB6235AD1AB6A   {   13 },
    $13726121572FE2FF   {   14 },    $1A488C6F199D921E   {   15 },
    $4BC9F9F4DA0007CA   {   16 },    $26F5E6F6E85241C7   {   17 },
    $859079DBEA5947B6   {   18 },    $4F1885C5C99E8C92   {   19 },
    $D78E761EA96F864B   {   20 },    $8E36428C52B5C17D   {   21 },
    $69CF6827373063C1   {   22 },    $B607C93D9BB4C56E   {   23 },
    $7D820E760E76B5EA   {   24 },    $645C9CC6F07FDC42   {   25 },
    $BF38A078243342E0   {   26 },    $5F6B343C9D2E7D04   {   27 },
    $F2C28AEB600B0EC6   {   28 },    $6C0ED85F7254BCAC   {   29 },
    $71592281A4DB4FE5   {   30 },    $1967FA69CE0FED9F   {   31 },
    $FD5293F8B96545DB   {   32 },    $C879E9D7F2A7600B   {   33 },
    $860248920193194E   {   34 },    $A4F9533B2D9CC0B3   {   35 },
    $9053836C15957613   {   36 },    $DB6DCF8AFC357BF1   {   37 },
    $18BEEA7A7A370F57   {   38 },    $037117CA50B99066   {   39 },
    $6AB30A9774424A35   {   40 },    $F4E92F02E325249B   {   41 },
    $7739DB07061CCAE1   {   42 },    $D8F3B49CECA42A05   {   43 },
    $BD56BE3F51382F73   {   44 },    $45FAED5843B0BB28   {   45 },
    $1C813D5C11BF1F83   {   46 },    $8AF0E4B6D75FA169   {   47 },
    $33EE18A487AD9999   {   48 },    $3C26E8EAB1C94410   {   49 },
    $B510102BC0A822F9   {   50 },    $141EEF310CE6123B   {   51 },
    $FC65B90059DDB154   {   52 },    $E0158640C5E0E607   {   53 },
    $884E079826C3A3CF   {   54 },    $930D0D9523C535FD   {   55 },
    $35638D754E9A2B00   {   56 },    $4085FCCF40469DD5   {   57 },
    $C4B17AD28BE23A4C   {   58 },    $CAB2F0FC6A3E6A2E   {   59 },
    $2860971A6B943FCD   {   60 },    $3DDE6EE212E30446   {   61 },
    $6222F32AE01765AE   {   62 },    $5D550BB5478308FE   {   63 },
    $A9EFA98DA0EDA22A   {   64 },    $C351A71686C40DA7   {   65 },
    $1105586D9C867C84   {   66 },    $DCFFEE85FDA22853   {   67 },
    $CCFBD0262C5EEF76   {   68 },    $BAF294CB8990D201   {   69 },
    $E69464F52AFAD975   {   70 },    $94B013AFDF133E14   {   71 },
    $06A7D1A32823C958   {   72 },    $6F95FE5130F61119   {   73 },
    $D92AB34E462C06C0   {   74 },    $ED7BDE33887C71D2   {   75 },
    $79746D6E6518393E   {   76 },    $5BA419385D713329   {   77 },
    $7C1BA6B948A97564   {   78 },    $31987C197BFDAC67   {   79 },
    $DE6C23C44B053D02   {   80 },    $581C49FED002D64D   {   81 },
    $DD474D6338261571   {   82 },    $AA4546C3E473D062   {   83 },
    $928FCE349455F860   {   84 },    $48161BBACAAB94D9   {   85 },
    $63912430770E6F68   {   86 },    $6EC8A5E602C6641C   {   87 },
    $87282515337DDD2B   {   88 },    $2CDA6B42034B701B   {   89 },
    $B03D37C181CB096D   {   90 },    $E108438266C71C6F   {   91 },
    $2B3180C7EB51B255   {   92 },    $DF92B82F96C08BBC   {   93 },
    $5C68C8C0A632F3BA   {   94 },    $5504CC861C3D0556   {   95 },
    $ABBFA4E55FB26B8F   {   96 },    $41848B0AB3BACEB4   {   97 },
    $B334A273AA445D32   {   98 },    $BCA696F0A85AD881   {   99 },
    $24F6EC65B528D56C   {  100 },    $0CE1512E90F4524A   {  101 },
    $4E9DD79D5506D35A   {  102 },    $258905FAC6CE9779   {  103 },
    $2019295B3E109B33   {  104 },    $F8A9478B73A054CC   {  105 },
    $2924F2F934417EB0   {  106 },    $3993357D536D1BC4   {  107 },
    $38A81AC21DB6FF8B   {  108 },    $47C4FBF17D6016BF   {  109 },
    $1E0FAADD7667E3F5   {  110 },    $7ABCFF62938BEB96   {  111 },
    $A78DAD948FC179C9   {  112 },    $8F1F98B72911E50D   {  113 },
    $61E48EAE27121A91   {  114 },    $4D62F7AD31859808   {  115 },
    $ECEBA345EF5CEAEB   {  116 },    $F5CEB25EBC9684CE   {  117 },
    $F633E20CB7F76221   {  118 },    $A32CDF06AB8293E4   {  119 },
    $985A202CA5EE2CA4   {  120 },    $CF0B8447CC8A8FB1   {  121 },
    $9F765244979859A3   {  122 },    $A8D516B1A1240017   {  123 },
    $0BD7BA3EBB5DC726   {  124 },    $E54BCA55B86ADB39   {  125 },
    $1D7A3AFD6C478063   {  126 },    $519EC608E7669EDD   {  127 },
    $0E5715A2D149AA23   {  128 },    $177D4571848FF194   {  129 },
    $EEB55F3241014C22   {  130 },    $0F5E5CA13A6E2EC2   {  131 },
    $8029927B75F5C361   {  132 },    $AD139FABC3D6E436   {  133 },
    $0D5DF1A94CCF402F   {  134 },    $3E8BD948BEA5DFC8   {  135 },
    $A5A0D357BD3FF77E   {  136 },    $A2D12E251F74F645   {  137 },
    $66FD9E525E81A082   {  138 },    $2E0C90CE7F687A49   {  139 },
    $C2E8BCBEBA973BC5   {  140 },    $000001BCE509745F   {  141 },
    $423777BBE6DAB3D6   {  142 },    $D1661C7EAEF06EB5   {  143 },
    $A1781F354DAACFD8   {  144 },    $2D11284A2B16AFFC   {  145 },
    $F1FC4F67FA891D1F   {  146 },    $73ECC25DCB920ADA   {  147 },
    $AE610C22C2A12651   {  148 },    $96E0A810D356B78A   {  149 },
    $5A9A381F2FE7870F   {  150 },    $D5AD62EDE94E5530   {  151 },
    $D225E5E8368D1427   {  152 },    $65977B70C7AF4631   {  153 },
    $99F889B2DE39D74F   {  154 },    $233F30BF54E1D143   {  155 },
    $9A9675D3D9A63C97   {  156 },    $5470554FF334F9A8   {  157 },
    $166ACB744A4F5688   {  158 },    $70C74CAAB2E4AEAD   {  159 },
    $F0D091646F294D12   {  160 },    $57B82A89684031D1   {  161 },
    $EFD95A5A61BE0B6B   {  162 },    $2FBD12E969F2F29A   {  163 },
    $9BD37013FEFF9FE8   {  164 },    $3F9B0404D6085A06   {  165 },
    $4940C1F3166CFE15   {  166 },    $09542C4DCDF3DEFB   {  167 },
    $B4C5218385CD5CE3   {  168 },    $C935B7DC4462A641   {  169 },
    $3417F8A68ED3B63F   {  170 },    $B80959295B215B40   {  171 },
    $F99CDAEF3B8C8572   {  172 },    $018C0614F8FCB95D   {  173 },
    $1B14ACCD1A3ACDF3   {  174 },    $84D471F200BB732D   {  175 },
    $C1A3110E95E8DA16   {  176 },    $430A7220BF1A82B8   {  177 },
    $B77E090D39DF210E   {  178 },    $5EF4BD9F3CD05E9D   {  179 },
    $9D4FF6DA7E57A444   {  180 },    $DA1D60E183D4A5F8   {  181 },
    $B287C38417998E47   {  182 },    $FE3EDC121BB31886   {  183 },
    $C7FE3CCC980CCBEF   {  184 },    $E46FB590189BFD03   {  185 },
    $3732FD469A4C57DC   {  186 },    $7EF700A07CF1AD65   {  187 },
    $59C64468A31D8859   {  188 },    $762FB0B4D45B61F6   {  189 },
    $155BAED099047718   {  190 },    $68755E4C3D50BAA6   {  191 },
    $E9214E7F22D8B4DF   {  192 },    $2ADDBF532EAC95F4   {  193 },
    $32AE3909B4BD0109   {  194 },    $834DF537B08E3450   {  195 },
    $FA209DA84220728D   {  196 },    $9E691D9B9EFE23F7   {  197 },
    $0446D288C4AE8D7F   {  198 },    $7B4CC524E169785B   {  199 },
    $21D87F0135CA1385   {  200 },    $CEBB400F137B8AA5   {  201 },
    $272E2B66580796BE   {  202 },    $3612264125C2B0DE   {  203 },
    $057702BDAD1EFBB2   {  204 },    $D4BABB8EACF84BE9   {  205 },
    $91583139641BC67B   {  206 },    $8BDC2DE08036E024   {  207 },
    $603C8156F49F68ED   {  208 },    $F7D236F7DBEF5111   {  209 },
    $9727C4598AD21E80   {  210 },    $A08A0896670A5FD7   {  211 },
    $CB4A8F4309EBA9CB   {  212 },    $81AF564B0F7036A1   {  213 },
    $C0B99AA778199ABD   {  214 },    $959F1EC83FC8E952   {  215 },
    $8C505077794A81B9   {  216 },    $3ACAAF8F056338F0   {  217 },
    $07B43F50627A6778   {  218 },    $4A44AB49F5ECCC77   {  219 },
    $3BC3D6E4B679EE98   {  220 },    $9CC0D4D1CF14108C   {  221 },
    $4406C00B206BC8A0   {  222 },    $82A18854C8D72D89   {  223 },
    $67E366B35C3C432C   {  224 },    $B923DD61102B37F2   {  225 },
    $56AB2779D884271D   {  226 },    $BE83E1B0FF1525AF   {  227 },
    $FB7C65D4217E49A9   {  228 },    $6BDBE0E76D48E7D4   {  229 },
    $08DF828745D9179E   {  230 },    $22EA6A9ADD53BD34   {  231 },
    $E36E141C5622200A   {  232 },    $7F805D1B8CB750EE   {  233 },
    $AFE5C7A59F58E837   {  234 },    $E27F996A4FB1C23C   {  235 },
    $D3867DFB0775F0D0   {  236 },    $D0E673DE6E88891A   {  237 },
    $123AEB9EAFB86C25   {  238 },    $30F1D5D5C145B895   {  239 },
    $BB434A2DEE7269E7   {  240 },    $78CB67ECF931FA38   {  241 },
    $F33B0372323BBF9C   {  242 },    $52D66336FB279C74   {  243 },
    $505F33AC0AFB4EAA   {  244 },    $E8A5CD99A2CCE187   {  245 },
    $534974801E2D30BB   {  246 },    $8D2D5711D5876D90   {  247 },
    $1F1A412891BC038E   {  248 },    $D6E2E71D82E56648   {  249 },
    $74036C3A497732B7   {  250 },    $89B67ED96361F5AB   {  251 },
    $FFED95D8F1EA02A2   {  252 },    $E72B3BD61464D43D   {  253 },
    $A6300F170BDC4820   {  254 },    $EBC18760ED78A77A   {  255 },
    $E6A6BE5A05A12138   {  256 },    $B5A122A5B4F87C98   {  257 },
    $563C6089140B6990   {  258 },    $4C46CB2E391F5DD5   {  259 },
    $D932ADDBC9B79434   {  260 },    $08EA70E42015AFF5   {  261 },
    $D765A6673E478CF1   {  262 },    $C4FB757EAB278D99   {  263 },
    $DF11C6862D6E0692   {  264 },    $DDEB84F10D7F3B16   {  265 },
    $6F2EF604A665EA04   {  266 },    $4A8E0F0FF0E0DFB3   {  267 },
    $A5EDEEF83DBCBA51   {  268 },    $FC4F0A2A0EA4371E   {  269 },
    $E83E1DA85CB38429   {  270 },    $DC8FF882BA1B1CE2   {  271 },
    $CD45505E8353E80D   {  272 },    $18D19A00D4DB0717   {  273 },
    $34A0CFEDA5F38101   {  274 },    $0BE77E518887CAF2   {  275 },
    $1E341438B3C45136   {  276 },    $E05797F49089CCF9   {  277 },
    $FFD23F9DF2591D14   {  278 },    $543DDA228595C5CD   {  279 },
    $661F81FD99052A33   {  280 },    $8736E641DB0F7B76   {  281 },
    $15227725418E5307   {  282 },    $E25F7F46162EB2FA   {  283 },
    $48A8B2126C13D9FE   {  284 },    $AFDC541792E76EEA   {  285 },
    $03D912BFC6D1898F   {  286 },    $31B1AAFA1B83F51B   {  287 },
    $F1AC2796E42AB7D9   {  288 },    $40A3A7D7FCD2EBAC   {  289 },
    $1056136D0AFBBCC5   {  290 },    $7889E1DD9A6D0C85   {  291 },
    $D33525782A7974AA   {  292 },    $A7E25D09078AC09B   {  293 },
    $BD4138B3EAC6EDD0   {  294 },    $920ABFBE71EB9E70   {  295 },
    $A2A5D0F54FC2625C   {  296 },    $C054E36B0B1290A3   {  297 },
    $F6DD59FF62FE932B   {  298 },    $3537354511A8AC7D   {  299 },
    $CA845E9172FADCD4   {  300 },    $84F82B60329D20DC   {  301 },
    $79C62CE1CD672F18   {  302 },    $8B09A2ADD124642C   {  303 },
    $D0C1E96A19D9E726   {  304 },    $5A786A9B4BA9500C   {  305 },
    $0E020336634C43F3   {  306 },    $C17B474AEB66D822   {  307 },
    $6A731AE3EC9BAAC2   {  308 },    $8226667AE0840258   {  309 },
    $67D4567691CAECA5   {  310 },    $1D94155C4875ADB5   {  311 },
    $6D00FD985B813FDF   {  312 },    $51286EFCB774CD06   {  313 },
    $5E8834471FA744AF   {  314 },    $F72CA0AEE761AE2E   {  315 },
    $BE40E4CDAEE8E09A   {  316 },    $E9970BBB5118F665   {  317 },
    $726E4BEB33DF1964   {  318 },    $703B000729199762   {  319 },
    $4631D816F5EF30A7   {  320 },    $B880B5B51504A6BE   {  321 },
    $641793C37ED84B6C   {  322 },    $7B21ED77F6E97D96   {  323 },
    $776306312EF96B73   {  324 },    $AE528948E86FF3F4   {  325 },
    $53DBD7F286A3F8F8   {  326 },    $16CADCE74CFC1063   {  327 },
    $005C19BDFA52C6DD   {  328 },    $68868F5D64D46AD3   {  329 },
    $3A9D512CCF1E186A   {  330 },    $367E62C2385660AE   {  331 },
    $E359E7EA77DCB1D7   {  332 },    $526C0773749ABE6E   {  333 },
    $735AE5F9D09F734B   {  334 },    $493FC7CC8A558BA8   {  335 },
    $B0B9C1533041AB45   {  336 },    $321958BA470A59BD   {  337 },
    $852DB00B5F46C393   {  338 },    $91209B2BD336B0E5   {  339 },
    $6E604F7D659EF19F   {  340 },    $B99A8AE2782CCB24   {  341 },
    $CCF52AB6C814C4C7   {  342 },    $4727D9AFBE11727B   {  343 },
    $7E950D0C0121B34D   {  344 },    $756F435670AD471F   {  345 },
    $F5ADD442615A6849   {  346 },    $4E87E09980B9957A   {  347 },
    $2ACFA1DF50AEE355   {  348 },    $D898263AFD2FD556   {  349 },
    $C8F4924DD80C8FD6   {  350 },    $CF99CA3D754A173A   {  351 },
    $FE477BACAF91BF3C   {  352 },    $ED5371F6D690C12D   {  353 },
    $831A5C285E687094   {  354 },    $C5D3C90A3708A0A4   {  355 },
    $0F7F903717D06580   {  356 },    $19F9BB13B8FDF27F   {  357 },
    $B1BD6F1B4D502843   {  358 },    $1C761BA38FFF4012   {  359 },
    $0D1530C4E2E21F3B   {  360 },    $8943CE69A7372C8A   {  361 },
    $E5184E11FEB5CE66   {  362 },    $618BDB80BD736621   {  363 },
    $7D29BAD68B574D0B   {  364 },    $81BB613E25E6FE5B   {  365 },
    $071C9C10BC07913F   {  366 },    $C7BEEB7909AC2D97   {  367 },
    $C3E58D353BC5D757   {  368 },    $EB017892F38F61E8   {  369 },
    $D4EFFB9C9B1CC21A   {  370 },    $99727D26F494F7AB   {  371 },
    $A3E063A2956B3E03   {  372 },    $9D4A8B9A4AA09C30   {  373 },
    $3F6AB7D500090FB4   {  374 },    $9CC0F2A057268AC0   {  375 },
    $3DEE9D2DEDBF42D1   {  376 },    $330F49C87960A972   {  377 },
    $C6B2720287421B41   {  378 },    $0AC59EC07C00369C   {  379 },
    $EF4EAC49CB353425   {  380 },    $F450244EEF0129D8   {  381 },
    $8ACC46E5CAF4DEB6   {  382 },    $2FFEAB63989263F7   {  383 },
    $8F7CB9FE5D7A4578   {  384 },    $5BD8F7644E634635   {  385 },
    $427A7315BF2DC900   {  386 },    $17D0C4AA2125261C   {  387 },
    $3992486C93518E50   {  388 },    $B4CBFEE0A2D7D4C3   {  389 },
    $7C75D6202C5DDD8D   {  390 },    $DBC295D8E35B6C61   {  391 },
    $60B369D302032B19   {  392 },    $CE42685FDCE44132   {  393 },
    $06F3DDB9DDF65610   {  394 },    $8EA4D21DB5E148F0   {  395 },
    $20B0FCE62FCD496F   {  396 },    $2C1B912358B0EE31   {  397 },
    $B28317B818F5A308   {  398 },    $A89C1E189CA6D2CF   {  399 },
    $0C6B18576AAADBC8   {  400 },    $B65DEAA91299FAE3   {  401 },
    $FB2B794B7F1027E7   {  402 },    $04E4317F443B5BEB   {  403 },
    $4B852D325939D0A6   {  404 },    $D5AE6BEEFB207FFC   {  405 },
    $309682B281C7D374   {  406 },    $BAE309A194C3B475   {  407 },
    $8CC3F97B13B49F05   {  408 },    $98A9422FF8293967   {  409 },
    $244B16B01076FF7C   {  410 },    $F8BF571C663D67EE   {  411 },
    $1F0D6758EEE30DA1   {  412 },    $C9B611D97ADEB9B7   {  413 },
    $B7AFD5887B6C57A2   {  414 },    $6290AE846B984FE1   {  415 },
    $94DF4CDEACC1A5FD   {  416 },    $058A5BD1C5483AFF   {  417 },
    $63166CC142BA3C37   {  418 },    $8DB8526EB2F76F40   {  419 },
    $E10880036F0D6D4E   {  420 },    $9E0523C9971D311D   {  421 },
    $45EC2824CC7CD691   {  422 },    $575B8359E62382C9   {  423 },
    $FA9E400DC4889995   {  424 },    $D1823ECB45721568   {  425 },
    $DAFD983B8206082F   {  426 },    $AA7D29082386A8CB   {  427 },
    $269FCD4403B87588   {  428 },    $1B91F5F728BDD1E0   {  429 },
    $E4669F39040201F6   {  430 },    $7A1D7C218CF04ADE   {  431 },
    $65623C29D79CE5CE   {  432 },    $2368449096C00BB1   {  433 },
    $AB9BF1879DA503BA   {  434 },    $BC23ECB1A458058E   {  435 },
    $9A58DF01BB401ECC   {  436 },    $A070E868A85F143D   {  437 },
    $4FF188307DF2239E   {  438 },    $14D565B41A641183   {  439 },
    $EE13337452701602   {  440 },    $950E3DCF3F285E09   {  441 },
    $59930254B9C80953   {  442 },    $3BF299408930DA6D   {  443 },
    $A955943F53691387   {  444 },    $A15EDECAA9CB8784   {  445 },
    $29142127352BE9A0   {  446 },    $76F0371FFF4E7AFB   {  447 },
    $0239F450274F2228   {  448 },    $BB073AF01D5E868B   {  449 },
    $BFC80571C10E96C1   {  450 },    $D267088568222E23   {  451 },
    $9671A3D48E80B5B0   {  452 },    $55B5D38AE193BB81   {  453 },
    $693AE2D0A18B04B8   {  454 },    $5C48B4ECADD5335F   {  455 },
    $FD743B194916A1CA   {  456 },    $2577018134BE98C4   {  457 },
    $E77987E83C54A4AD   {  458 },    $28E11014DA33E1B9   {  459 },
    $270CC59E226AA213   {  460 },    $71495F756D1A5F60   {  461 },
    $9BE853FB60AFEF77   {  462 },    $ADC786A7F7443DBF   {  463 },
    $0904456173B29A82   {  464 },    $58BC7A66C232BD5E   {  465 },
    $F306558C673AC8B2   {  466 },    $41F639C6B6C9772A   {  467 },
    $216DEFE99FDA35DA   {  468 },    $11640CC71C7BE615   {  469 },
    $93C43694565C5527   {  470 },    $EA038E6246777839   {  471 },
    $F9ABF3CE5A3E2469   {  472 },    $741E768D0FD312D2   {  473 },
    $0144B883CED652C6   {  474 },    $C20B5A5BA33F8552   {  475 },
    $1AE69633C3435A9D   {  476 },    $97A28CA4088CFDEC   {  477 },
    $8824A43C1E96F420   {  478 },    $37612FA66EEEA746   {  479 },
    $6B4CB165F9CF0E5A   {  480 },    $43AA1C06A0ABFB4A   {  481 },
    $7F4DC26FF162796B   {  482 },    $6CBACC8E54ED9B0F   {  483 },
    $A6B7FFEFD2BB253E   {  484 },    $2E25BC95B0A29D4F   {  485 },
    $86D6A58BDEF1388C   {  486 },    $DED74AC576B6F054   {  487 },
    $8030BDBC2B45805D   {  488 },    $3C81AF70E94D9289   {  489 },
    $3EFF6DDA9E3100DB   {  490 },    $B38DC39FDFCC8847   {  491 },
    $123885528D17B87E   {  492 },    $F2DA0ED240B1B642   {  493 },
    $44CEFADCD54BF9A9   {  494 },    $1312200E433C7EE6   {  495 },
    $9FFCC84F3A78C748   {  496 },    $F0CD1F72248576BB   {  497 },
    $EC6974053638CFE4   {  498 },    $2BA7B67C0CEC4E4C   {  499 },
    $AC2F4DF3E5CE32ED   {  500 },    $CB33D14326EA4C11   {  501 },
    $A4E9044CC77E58BC   {  502 },    $5F513293D934FCEF   {  503 },
    $5DC9645506E55444   {  504 },    $50DE418F317DE40A   {  505 },
    $388CB31A69DDE259   {  506 },    $2DB4A83455820A86   {  507 },
    $9010A91E84711AE9   {  508 },    $4DF7F0B7B1498371   {  509 },
    $D62A2EABC0977179   {  510 },    $22FAC097AA8D5C0E   {  511 },
    $F49FCC2FF1DAF39B   {  512 },    $487FD5C66FF29281   {  513 },
    $E8A30667FCDCA83F   {  514 },    $2C9B4BE3D2FCCE63   {  515 },
    $DA3FF74B93FBBBC2   {  516 },    $2FA165D2FE70BA66   {  517 },
    $A103E279970E93D4   {  518 },    $BECDEC77B0E45E71   {  519 },
    $CFB41E723985E497   {  520 },    $B70AAA025EF75017   {  521 },
    $D42309F03840B8E0   {  522 },    $8EFC1AD035898579   {  523 },
    $96C6920BE2B2ABC5   {  524 },    $66AF4163375A9172   {  525 },
    $2174ABDCCA7127FB   {  526 },    $B33CCEA64A72FF41   {  527 },
    $F04A4933083066A5   {  528 },    $8D970ACDD7289AF5   {  529 },
    $8F96E8E031C8C25E   {  530 },    $F3FEC02276875D47   {  531 },
    $EC7BF310056190DD   {  532 },    $F5ADB0AEBB0F1491   {  533 },
    $9B50F8850FD58892   {  534 },    $4975488358B74DE8   {  535 },
    $A3354FF691531C61   {  536 },    $0702BBE481D2C6EE   {  537 },
    $89FB24057DEDED98   {  538 },    $AC3075138596E902   {  539 },
    $1D2D3580172772ED   {  540 },    $EB738FC28E6BC30D   {  541 },
    $5854EF8F63044326   {  542 },    $9E5C52325ADD3BBE   {  543 },
    $90AA53CF325C4623   {  544 },    $C1D24D51349DD067   {  545 },
    $2051CFEEA69EA624   {  546 },    $13220F0A862E7E4F   {  547 },
    $CE39399404E04864   {  548 },    $D9C42CA47086FCB7   {  549 },
    $685AD2238A03E7CC   {  550 },    $066484B2AB2FF1DB   {  551 },
    $FE9D5D70EFBF79EC   {  552 },    $5B13B9DD9C481854   {  553 },
    $15F0D475ED1509AD   {  554 },    $0BEBCD060EC79851   {  555 },
    $D58C6791183AB7F8   {  556 },    $D1187C5052F3EEE4   {  557 },
    $C95D1192E54E82FF   {  558 },    $86EEA14CB9AC6CA2   {  559 },
    $3485BEB153677D5D   {  560 },    $DD191D781F8C492A   {  561 },
    $F60866BAA784EBF9   {  562 },    $518F643BA2D08C74   {  563 },
    $8852E956E1087C22   {  564 },    $A768CB8DC410AE8D   {  565 },
    $38047726BFEC8E1A   {  566 },    $A67738B4CD3B45AA   {  567 },
    $AD16691CEC0DDE19   {  568 },    $C6D4319380462E07   {  569 },
    $C5A5876D0BA61938   {  570 },    $16B9FA1FA58FD840   {  571 },
    $188AB1173CA74F18   {  572 },    $ABDA2F98C99C021F   {  573 },
    $3E0580AB134AE816   {  574 },    $5F3B05B773645ABB   {  575 },
    $2501A2BE5575F2F6   {  576 },    $1B2F74004E7E8BA9   {  577 },
    $1CD7580371E8D953   {  578 },    $7F6ED89562764E30   {  579 },
    $B15926FF596F003D   {  580 },    $9F65293DA8C5D6B9   {  581 },
    $6ECEF04DD690F84C   {  582 },    $4782275FFF33AF88   {  583 },
    $E41433083F820801   {  584 },    $FD0DFE409A1AF9B5   {  585 },
    $4325A3342CDB396B   {  586 },    $8AE77E62B301B252   {  587 },
    $C36F9E9F6655615A   {  588 },    $85455A2D92D32C09   {  589 },
    $F2C7DEA949477485   {  590 },    $63CFB4C133A39EBA   {  591 },
    $83B040CC6EBC5462   {  592 },    $3B9454C8FDB326B0   {  593 },
    $56F56A9E87FFD78C   {  594 },    $2DC2940D99F42BC6   {  595 },
    $98F7DF096B096E2D   {  596 },    $19A6E01E3AD852BF   {  597 },
    $42A99CCBDBD4B40B   {  598 },    $A59998AF45E9C559   {  599 },
    $366295E807D93186   {  600 },    $6B48181BFAA1F773   {  601 },
    $1FEC57E2157A0A1D   {  602 },    $4667446AF6201AD5   {  603 },
    $E615EBCACFB0F075   {  604 },    $B8F31F4F68290778   {  605 },
    $22713ED6CE22D11E   {  606 },    $3057C1A72EC3C93B   {  607 },
    $CB46ACC37C3F1F2F   {  608 },    $DBB893FD02AAF50E   {  609 },
    $331FD92E600B9FCF   {  610 },    $A498F96148EA3AD6   {  611 },
    $A8D8426E8B6A83EA   {  612 },    $A089B274B7735CDC   {  613 },
    $87F6B3731E524A11   {  614 },    $118808E5CBC96749   {  615 },
    $9906E4C7B19BD394   {  616 },    $AFED7F7E9B24A20C   {  617 },
    $6509EADEEB3644A7   {  618 },    $6C1EF1D3E8EF0EDE   {  619 },
    $B9C97D43E9798FB4   {  620 },    $A2F2D784740C28A3   {  621 },
    $7B8496476197566F   {  622 },    $7A5BE3E6B65F069D   {  623 },
    $F96330ED78BE6F10   {  624 },    $EEE60DE77A076A15   {  625 },
    $2B4BEE4AA08B9BD0   {  626 },    $6A56A63EC7B8894E   {  627 },
    $02121359BA34FEF4   {  628 },    $4CBF99F8283703FC   {  629 },
    $398071350CAF30C8   {  630 },    $D0A77A89F017687A   {  631 },
    $F1C1A9EB9E423569   {  632 },    $8C7976282DEE8199   {  633 },
    $5D1737A5DD1F7ABD   {  634 },    $4F53433C09A9FA80   {  635 },
    $FA8B0C53DF7CA1D9   {  636 },    $3FD9DCBC886CCB77   {  637 },
    $C040917CA91B4720   {  638 },    $7DD00142F9D1DCDF   {  639 },
    $8476FC1D4F387B58   {  640 },    $23F8E7C5F3316503   {  641 },
    $032A2244E7E37339   {  642 },    $5C87A5D750F5A74B   {  643 },
    $082B4CC43698992E   {  644 },    $DF917BECB858F63C   {  645 },
    $3270B8FC5BF86DDA   {  646 },    $10AE72BB29B5DD76   {  647 },
    $576AC94E7700362B   {  648 },    $1AD112DAC61EFB8F   {  649 },
    $691BC30EC5FAA427   {  650 },    $FF246311CC327143   {  651 },
    $3142368E30E53206   {  652 },    $71380E31E02CA396   {  653 },
    $958D5C960AAD76F1   {  654 },    $F8D6F430C16DA536   {  655 },
    $C8FFD13F1BE7E1D2   {  656 },    $7578AE66004DDBE1   {  657 },
    $05833F01067BE646   {  658 },    $BB34B5AD3BFE586D   {  659 },
    $095F34C9A12B97F0   {  660 },    $247AB64525D60CA8   {  661 },
    $DCDBC6F3017477D1   {  662 },    $4A2E14D4DECAD24D   {  663 },
    $BDB5E6D9BE0A1EEB   {  664 },    $2A7E70F7794301AB   {  665 },
    $DEF42D8A270540FD   {  666 },    $01078EC0A34C22C1   {  667 },
    $E5DE511AF4C16387   {  668 },    $7EBB3A52BD9A330A   {  669 },
    $77697857AA7D6435   {  670 },    $004E831603AE4C32   {  671 },
    $E7A21020AD78E312   {  672 },    $9D41A70C6AB420F2   {  673 },
    $28E06C18EA1141E6   {  674 },    $D2B28CBD984F6B28   {  675 },
    $26B75F6C446E9D83   {  676 },    $BA47568C4D418D7F   {  677 },
    $D80BADBFE6183D8E   {  678 },    $0E206D7F5F166044   {  679 },
    $E258A43911CBCA3E   {  680 },    $723A1746B21DC0BC   {  681 },
    $C7CAA854F5D7CDD3   {  682 },    $7CAC32883D261D9C   {  683 },
    $7690C26423BA942C   {  684 },    $17E55524478042B8   {  685 },
    $E0BE477656A2389F   {  686 },    $4D289B5E67AB2DA0   {  687 },
    $44862B9C8FBBFD31   {  688 },    $B47CC8049D141365   {  689 },
    $822C1B362B91C793   {  690 },    $4EB14655FB13DFD8   {  691 },
    $1ECBBA0714E2A97B   {  692 },    $6143459D5CDE5F14   {  693 },
    $53A8FBF1D5F0AC89   {  694 },    $97EA04D81C5E5B00   {  695 },
    $622181A8D4FDB3F3   {  696 },    $E9BCD341572A1208   {  697 },
    $1411258643CCE58A   {  698 },    $9144C5FEA4C6E0A4   {  699 },
    $0D33D06565CF620F   {  700 },    $54A48D489F219CA1   {  701 },
    $C43E5EAC6D63C821   {  702 },    $A9728B3A72770DAF   {  703 },
    $D7934E7B20DF87EF   {  704 },    $E35503B61A3E86E5   {  705 },
    $CAE321FBC819D504   {  706 },    $129A50B3AC60BFA6   {  707 },
    $CD5E68EA7E9FB6C3   {  708 },    $B01C90199483B1C7   {  709 },
    $3DE93CD5C295376C   {  710 },    $AED52EDF2AB9AD13   {  711 },
    $2E60F512C0A07884   {  712 },    $BC3D86A3E36210C9   {  713 },
    $35269D9B163951CE   {  714 },    $0C7D6E2AD0CDB5FA   {  715 },
    $59E86297D87F5733   {  716 },    $298EF221898DB0E7   {  717 },
    $55000029D1A5AA7E   {  718 },    $8BC08AE1B5061B45   {  719 },
    $C2C31C2B6C92703A   {  720 },    $94CC596BAF25EF42   {  721 },
    $0A1D73DB22540456   {  722 },    $04B6A0F9D9C4179A   {  723 },
    $EFFDAFA2AE3D3C60   {  724 },    $F7C8075BB49496C4   {  725 },
    $9CC5C7141D1CD4E3   {  726 },    $78BD1638218E5534   {  727 },
    $B2F11568F850246A   {  728 },    $EDFABCFA9502BC29   {  729 },
    $796CE5F2DA23051B   {  730 },    $AAE128B0DC93537C   {  731 },
    $3A493DA0EE4B29AE   {  732 },    $B5DF6B2C416895D7   {  733 },
    $FCABBD25122D7F37   {  734 },    $70810B58105DC4B1   {  735 },
    $E10FDD37F7882A90   {  736 },    $524DCAB5518A3F5C   {  737 },
    $3C9E85878451255B   {  738 },    $4029828119BD34E2   {  739 },
    $74A05B6F5D3CECCB   {  740 },    $B610021542E13ECA   {  741 },
    $0FF979D12F59E2AC   {  742 },    $6037DA27E4F9CC50   {  743 },
    $5E92975A0DF1847D   {  744 },    $D66DE190D3E623FE   {  745 },
    $5032D6B87B568048   {  746 },    $9A36B7CE8235216E   {  747 },
    $80272A7A24F64B4A   {  748 },    $93EFED8B8C6916F7   {  749 },
    $37DDBFF44CCE1555   {  750 },    $4B95DB5D4B99BD25   {  751 },
    $92D3FDA169812FC0   {  752 },    $FB1A4A9A90660BB6   {  753 },
    $730C196946A4B9B2   {  754 },    $81E289AA7F49DA68   {  755 },
    $64669A0F83B1A05F   {  756 },    $27B3FF7D9644F48B   {  757 },
    $CC6B615C8DB675B3   {  758 },    $674F20B9BCEBBE95   {  759 },
    $6F31238275655982   {  760 },    $5AE488713E45CF05   {  761 },
    $BF619F9954C21157   {  762 },    $EABAC46040A8EAE9   {  763 },
    $454C6FE9F2C0C1CD   {  764 },    $419CF6496412691C   {  765 },
    $D3DC3BEF265B0F70   {  766 },    $6D0E60F5C3578A9E   {  767 },
    $5B0E608526323C55   {  768 },    $1A46C1A9FA1B59F5   {  769 },
    $A9E245A17C4C8FFA   {  770 },    $65CA5159DB2955D7   {  771 },
    $05DB0A76CE35AFC2   {  772 },    $81EAC77EA9113D45   {  773 },
    $528EF88AB6AC0A0D   {  774 },    $A09EA253597BE3FF   {  775 },
    $430DDFB3AC48CD56   {  776 },    $C4B3A67AF45CE46F   {  777 },
    $4ECECFD8FBE2D05E   {  778 },    $3EF56F10B39935F0   {  779 },
    $0B22D6829CD619C6   {  780 },    $17FD460A74DF2069   {  781 },
    $6CF8CC8E8510ED40   {  782 },    $D6C824BF3A6ECAA7   {  783 },
    $61243D581A817049   {  784 },    $048BACB6BBC163A2   {  785 },
    $D9A38AC27D44CC32   {  786 },    $7FDDFF5BAAF410AB   {  787 },
    $AD6D495AA804824B   {  788 },    $E1A6A74F2D8C9F94   {  789 },
    $D4F7851235DEE8E3   {  790 },    $FD4B7F886540D893   {  791 },
    $247C20042AA4BFDA   {  792 },    $096EA1C517D1327C   {  793 },
    $D56966B4361A6685   {  794 },    $277DA5C31221057D   {  795 },
    $94D59893A43ACFF7   {  796 },    $64F0C51CCDC02281   {  797 },
    $3D33BCC4FF6189DB   {  798 },    $E005CB184CE66AF1   {  799 },
    $FF5CCD1D1DB99BEA   {  800 },    $B0B854A7FE42980F   {  801 },
    $7BD46A6A718D4B9F   {  802 },    $D10FA8CC22A5FD8C   {  803 },
    $D31484952BE4BD31   {  804 },    $C7FA975FCB243847   {  805 },
    $4886ED1E5846C407   {  806 },    $28CDDB791EB70B04   {  807 },
    $C2B00BE2F573417F   {  808 },    $5C9590452180F877   {  809 },
    $7A6BDDFFF370EB00   {  810 },    $CE509E38D6D9D6A4   {  811 },
    $EBEB0F00647FA702   {  812 },    $1DCC06CF76606F06   {  813 },
    $E4D9F28BA286FF0A   {  814 },    $D85A305DC918C262   {  815 },
    $475B1D8732225F54   {  816 },    $2D4FB51668CCB5FE   {  817 },
    $A679B9D9D72BBA20   {  818 },    $53841C0D912D43A5   {  819 },
    $3B7EAA48BF12A4E8   {  820 },    $781E0E47F22F1DDF   {  821 },
    $EFF20CE60AB50973   {  822 },    $20D261D19DFFB742   {  823 },
    $16A12B03062A2E39   {  824 },    $1960EB2239650495   {  825 },
    $251C16FED50EB8B8   {  826 },    $9AC0C330F826016E   {  827 },
    $ED152665953E7671   {  828 },    $02D63194A6369570   {  829 },
    $5074F08394B1C987   {  830 },    $70BA598C90B25CE1   {  831 },
    $794A15810B9742F6   {  832 },    $0D5925E9FCAF8C6C   {  833 },
    $3067716CD868744E   {  834 },    $910AB077E8D7731B   {  835 },
    $6A61BBDB5AC42F61   {  836 },    $93513EFBF0851567   {  837 },
    $F494724B9E83E9D5   {  838 },    $E887E1985C09648D   {  839 },
    $34B1D3C675370CFD   {  840 },    $DC35E433BC0D255D   {  841 },
    $D0AAB84234131BE0   {  842 },    $08042A50B48B7EAF   {  843 },
    $9997C4EE44A3AB35   {  844 },    $829A7B49201799D0   {  845 },
    $263B8307B7C54441   {  846 },    $752F95F4FD6A6CA6   {  847 },
    $927217402C08C6E5   {  848 },    $2A8AB754A795D9EE   {  849 },
    $A442F7552F72943D   {  850 },    $2C31334E19781208   {  851 },
    $4FA98D7CEAEE6291   {  852 },    $55C3862F665DB309   {  853 },
    $BD0610175D53B1F3   {  854 },    $46FE6CB840413F27   {  855 },
    $3FE03792DF0CFA59   {  856 },    $CFE700372EB85E8F   {  857 },
    $A7BE29E7ADBCE118   {  858 },    $E544EE5CDE8431DD   {  859 },
    $8A781B1B41F1873E   {  860 },    $A5C94C78A0D2F0E7   {  861 },
    $39412E2877B60728   {  862 },    $A1265EF3AFC9A62C   {  863 },
    $BCC2770C6A2506C5   {  864 },    $3AB66DD5DCE1CE12   {  865 },
    $E65499D04A675B37   {  866 },    $7D8F523481BFD216   {  867 },
    $0F6F64FCEC15F389   {  868 },    $74EFBE618B5B13C8   {  869 },
    $ACDC82B714273E1D   {  870 },    $DD40BFE003199D17   {  871 },
    $37E99257E7E061F8   {  872 },    $FA52626904775AAA   {  873 },
    $8BBBF63A463D56F9   {  874 },    $F0013F1543A26E64   {  875 },
    $A8307E9F879EC898   {  876 },    $CC4C27A4150177CC   {  877 },
    $1B432F2CCA1D3348   {  878 },    $DE1D1F8F9F6FA013   {  879 },
    $606602A047A7DDD6   {  880 },    $D237AB64CC1CB2C7   {  881 },
    $9B938E7225FCD1D3   {  882 },    $EC4E03708E0FF476   {  883 },
    $FEB2FBDA3D03C12D   {  884 },    $AE0BCED2EE43889A   {  885 },
    $22CB8923EBFB4F43   {  886 },    $69360D013CF7396D   {  887 },
    $855E3602D2D4E022   {  888 },    $073805BAD01F784C   {  889 },
    $33E17A133852F546   {  890 },    $DF4874058AC7B638   {  891 },
    $BA92B29C678AA14A   {  892 },    $0CE89FC76CFAADCD   {  893 },
    $5F9D4E0908339E34   {  894 },    $F1AFE9291F5923B9   {  895 },
    $6E3480F60F4A265F   {  896 },    $EEBF3A2AB29B841C   {  897 },
    $E21938A88F91B4AD   {  898 },    $57DFEFF845C6D3C3   {  899 },
    $2F006B0BF62CAAF2   {  900 },    $62F479EF6F75EE78   {  901 },
    $11A55AD41C8916A9   {  902 },    $F229D29084FED453   {  903 },
    $42F1C27B16B000E6   {  904 },    $2B1F76749823C074   {  905 },
    $4B76ECA3C2745360   {  906 },    $8C98F463B91691BD   {  907 },
    $14BCC93CF1ADE66A   {  908 },    $8885213E6D458397   {  909 },
    $8E177DF0274D4711   {  910 },    $B49B73B5503F2951   {  911 },
    $10168168C3F96B6B   {  912 },    $0E3D963B63CAB0AE   {  913 },
    $8DFC4B5655A1DB14   {  914 },    $F789F1356E14DE5C   {  915 },
    $683E68AF4E51DAC1   {  916 },    $C9A84F9D8D4B0FD9   {  917 },
    $3691E03F52A0F9D1   {  918 },    $5ED86E46E1878E80   {  919 },
    $3C711A0E99D07150   {  920 },    $5A0865B20C4E9310   {  921 },
    $56FBFC1FE4F0682E   {  922 },    $EA8D5DE3105EDF9B   {  923 },
    $71ABFDB12379187A   {  924 },    $2EB99DE1BEE77B9C   {  925 },
    $21ECC0EA33CF4523   {  926 },    $59A4D7521805C7A1   {  927 },
    $3896F5EB56AE7C72   {  928 },    $AA638F3DB18F75DC   {  929 },
    $9F39358DABE9808E   {  930 },    $B7DEFA91C00B72AC   {  931 },
    $6B5541FD62492D92   {  932 },    $6DC6DEE8F92E4D5B   {  933 },
    $353F57ABC4BEEA7E   {  934 },    $735769D6DA5690CE   {  935 },
    $0A234AA642391484   {  936 },    $F6F9508028F80D9D   {  937 },
    $B8E319A27AB3F215   {  938 },    $31AD9C1151341A4D   {  939 },
    $773C22A57BEF5805   {  940 },    $45C7561A07968633   {  941 },
    $F913DA9E249DBE36   {  942 },    $DA652D9B78A64C68   {  943 },
    $4C27A97F3BC334EF   {  944 },    $76621220E66B17F4   {  945 },
    $967743899ACD7D0B   {  946 },    $F3EE5BCAE0ED6782   {  947 },
    $409F753600C879FC   {  948 },    $06D09A39B5926DB6   {  949 },
    $6F83AEB0317AC588   {  950 },    $01E6CA4A86381F21   {  951 },
    $66FF3462D19F3025   {  952 },    $72207C24DDFD3BFB   {  953 },
    $4AF6B6D3E2ECE2EB   {  954 },    $9C994DBEC7EA08DE   {  955 },
    $49ACE597B09A8BC4   {  956 },    $B38C4766CF0797BA   {  957 },
    $131B9373C57C2A75   {  958 },    $B1822CCE61931E58   {  959 },
    $9D7555B909BA1C0C   {  960 },    $127FAFDD937D11D2   {  961 },
    $29DA3BADC66D92E4   {  962 },    $A2C1D57154C2ECBC   {  963 },
    $58C5134D82F6FE24   {  964 },    $1C3AE3515B62274F   {  965 },
    $E907C82E01CB8126   {  966 },    $F8ED091913E37FCB   {  967 },
    $3249D8F9C80046C9   {  968 },    $80CF9BEDE388FB63   {  969 },
    $1881539A116CF19E   {  970 },    $5103F3F76BD52457   {  971 },
    $15B7E6F5AE47F7A8   {  972 },    $DBD7C6DED47E9CCF   {  973 },
    $44E55C410228BB1A   {  974 },    $B647D4255EDB4E99   {  975 },
    $5D11882BB8AAFC30   {  976 },    $F5098BBB29D3212A   {  977 },
    $8FB5EA14E90296B3   {  978 },    $677B942157DD025A   {  979 },
    $FB58E7C0A390ACB5   {  980 },    $89D3674C83BD4A01   {  981 },
    $9E2DA4DF4BF3B93B   {  982 },    $FCC41E328CAB4829   {  983 },
    $03F38C96BA582C52   {  984 },    $CAD1BDBD7FD85DB2   {  985 },
    $BBB442C16082AE83   {  986 },    $B95FE86BA5DA9AB0   {  987 },
    $B22E04673771A93F   {  988 },    $845358C9493152D8   {  989 },
    $BE2A488697B4541E   {  990 },    $95A2DC2DD38E6966   {  991 },
    $C02C11AC923C852B   {  992 },    $2388B1990DF2A87B   {  993 },
    $7C8008FA1B4F37BE   {  994 },    $1F70D0C84D54E503   {  995 },
    $5490ADEC7ECE57D4   {  996 },    $002B3C27D9063A3A   {  997 },
    $7EAEA3848030A2BF   {  998 },    $C602326DED2003C0   {  999 },
    $83A7287D69A94086   { 1000 },    $C57A5FCB30F57A8A   { 1001 },
    $B56844E479EBE779   { 1002 },    $A373B40F05DCBCE9   { 1003 },
    $D71A786E88570EE2   { 1004 },    $879CBACDBDE8F6A0   { 1005 },
    $976AD1BCC164A32F   { 1006 },    $AB21E25E9666D78B   { 1007 },
    $901063AAE5E5C33C   { 1008 },    $9818B34448698D90   { 1009 },
    $E36487AE3E1E8ABB   { 1010 },    $AFBDF931893BDCB4   { 1011 },
    $6345A0DC5FBBD519   { 1012 },    $8628FE269B9465CA   { 1013 },
    $1E5D01603F9C51EC   { 1014 },    $4DE44006A15049B7   { 1015 },
    $BF6C70E5F776CBB1   { 1016 },    $411218F2EF552BED   { 1017 },
    $CB0C0708705A36A3   { 1018 },    $E74D14754F986044   { 1019 },
    $CD56D9430EA8280E   { 1020 },    $C12591D7535F5065   { 1021 },
    $C83223F1720AEF96   { 1022 },    $C3A0396F7363A51F   { 1023 }
);

implementation

END.

