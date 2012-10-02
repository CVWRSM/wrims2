module fnet_JP

! a = 0.00019973
! b = 0.064992

intrinsic Reshape
real, dimension(8,126) :: input = &
  Reshape((/0.847465246862,-0.699309138286,-0.094766661902,2.002961374417,2.124298743476,-0.791170213401,0.082653779743,-0.386414404323,-1.516892495816,1.020717942566,-0.292039194281,-3.629037929797 &
            ,-2.683672042979,0.436511895585,-0.024209249656,1.337781991227,0.171198632744,-3.278823378246,0.708423449191,0.569451074119,-0.547878005700,0.961407205213,0.280117605891,-0.400505810561 &
            ,0.159852287067,0.849256112515,-0.101092656068,0.391528075258,0.525166908880,-0.734264493897,0.835804080961,0.326527824364,1.829400518219,-3.518775861144,-1.299073721500,-1.362347209414 &
            ,-1.280589127584,0.320916672446,2.447505509453,-2.815508958891,-1.897849321025,6.527470574434,0.527800811783,1.004949751018,1.896344443036,-0.670326034057,-2.154973752196,2.031145483527 &
            ,0.672269166889,-3.003091622472,-0.709945164819,-3.396464419783,-4.361585772239,-0.182958563002,0.257385137484,0.122190677421,0.363288981488,-2.604380301409,0.508248400108,3.009569418695 &
            ,2.871227719608,0.585339933376,-0.679492418199,-1.297041803194,1.903310228931,-0.657119482274,-1.418541749837,-1.585915269765,-2.150602626925,-0.837093950954,0.009110356516,-1.024179910075 &
            ,0.943156724024,-2.596010193928,-0.656411272014,-1.024466396597,-0.796367679787,-1.037963857981,-1.193190146203,0.831788360769,-1.350259756997,0.910568420685,0.636788902206,0.781744180015 &
            ,0.880016703570,0.052950423079,0.144909279671,0.263810425373,-0.952255479813,1.403007672380,0.038060192326,-0.413042997649,-0.015519304078,-0.490541074204,-0.419356131571,0.763579356897 &
            ,0.350587590988,0.453895445938,-0.081324847284,0.377875311418,0.357148602765,0.352987074271,0.882290792585,-0.891564873060,-0.321754603648,2.306126929213,0.451644281782,0.447922085377 &
            ,1.248379321821,1.105846735661,0.395833828823,0.296200763107,-0.146968131971,1.047544167701,0.562472702907,0.679133823322,0.176379721026,0.771954073278,0.783173742505,-0.250676749273 &
            ,1.022387468712,-1.511560312008,-0.999118275779,-0.406960587964,-0.580968956307,-1.685270472257,-1.355234318540,-0.064308421795,-0.166630372427,-0.820086009825,0.266638007640,0.013912119967 &
            ,-0.342255806152,0.676180413241,0.017754995620,-0.312476908197,-0.077214212223,0.845695615165,0.160953689696,-0.082635272306,-0.054525281296,0.314937208511,-0.371835985500,0.502095330425 &
            ,0.244530803418,-3.501992649536,-0.262591996616,-2.749742867525,-3.568812498759,0.981243876707,0.062595817928,-0.545301988249,-0.489798533954,3.606310664656,-0.007003707145,-0.357302577878 &
            ,0.948874987590,1.666551721060,-1.058540637003,-0.004626941543,1.239100475635,0.596191709182,-1.069647081262,-2.059800567294,-1.440878770078,0.505373242164,0.754154884279,-1.017691004530 &
            ,-0.152849894890,-2.254987705714,0.752759212077,1.716267026492,0.989685513346,0.589256259881,0.064555887734,-0.604010539594,-0.603838028148,-1.526272341771,0.122888421717,2.584377693567 &
            ,2.665838577981,-2.312617008400,-3.292280214674,1.134440545972,0.946192992783,4.288387232732,0.258445950007,1.522149515553,0.985537243372,0.894846118887,1.736404022421,-1.504289859343 &
            ,2.256159182384,0.799056192684,-2.283972420099,-4.759230811543,-4.970346287502,-1.347087810283,2.779180768445,-1.718913601514,0.559894666204,0.289097435010,0.358126874253,-1.545433468037 &
            ,-2.798726510731,1.679404598295,0.228457336185,-0.183098304523,0.999272586928,2.227785012754,1.440104694942,8.587409740298,8.906688064065,-1.627011734509,-2.412564565999,0.507148371487 &
            ,-2.848892309383,0.822657277328,0.881831822674,-3.475734187976,-3.552885835645,1.252596460384,-0.171318968079,1.420953299963,0.491931590593,0.926666497619,0.103236332988,0.401959532175 &
            ,0.462832600867,0.965336398218,1.060238936223,-0.980761866780,-1.286611702176,0.890869644116,0.929354020592,0.660564060705,0.529492266155,0.806902649818,-0.192801129745,0.445200643215 &
            ,-0.547765431761,2.086255316390,0.244579219451,-0.583200773064,-0.676823619119,0.552711455505,-0.452623487167,0.292928307502,0.958529973319,-0.089267974820,-0.483457037006,0.103214283340 &
            ,0.640722392714,-0.146334424305,1.010350517471,-0.531799751201,0.038983137283,-1.169101555894,-0.177816888116,0.267706370909,0.428795029330,-0.912560655772,-1.000694936390,0.468058820534 &
            ,0.722206589668,-0.310939586357,-0.299236506933,0.524230732581,0.599497330103,0.011425880318,1.403116179149,-1.390463187520,0.597263986571,1.439115218559,-0.975826695174,0.072127987351 &
            ,1.014176837980,-1.468797254927,-0.645534346460,-0.156696908913,1.055495525175,0.342404305768,-0.762956657590,-1.566992768068,-1.682041446165,0.105604870964,0.559253022738,-0.718253801643 &
            ,-1.629314287110,-0.029738177754,2.588812623435,3.627454529155,4.760600687061,4.114365435762,-0.902036733397,0.730839934056,0.589737604530,-3.183443277086,-0.162870627950,-1.129127886981 &
            ,-2.144746859444,-0.227272876222,-3.150302636958,1.756818380478,-2.071812441040,1.432002335925,2.188059182279,4.282611293127,5.487918949162,2.162237542277,-2.919779377272,1.663144029214 &
            ,-2.129077542939,-0.289904455171,1.163331380341,-1.095513314407,-1.592629314802,1.072850073247,-1.612417843272,1.803855480318,-1.807050630679,3.027938488558,1.121858134380,1.031229159282 &
            ,2.074929958113,1.080196068593,-1.714791457168,1.772073101550,-1.459773344296,-2.384096366087,-0.883867687617,-1.553118952086,-1.284742268223,-3.477948137188,0.994882865889,0.517266680106 &
            ,-2.318494856501,-0.792703827250,0.899115152514,2.158144046961,4.304988715794,-0.078201069988,2.075010488566,0.101510326808,1.809143903369,-2.503058677540,-2.504700500299,-3.310383202732 &
            ,-2.448090722323,-2.800565735512,1.343387183040,-0.996041880267,-1.784382292222,-1.057895825928,1.563721028964,2.837800833639,3.404369361431,2.293874735408,0.992911156555,-0.994077635159 &
            ,-3.381400295348,-2.107036808043,2.763793268867,-0.107119041943,-1.462753167271,4.095469065761,2.804008043740,-0.540150317757,-0.408795506671,1.071151537919,0.230980229165,-0.050479510169 &
            ,-0.286399082657,-0.131481818750,-0.185996041271,0.626142616880,-0.727872302243,-2.008813724571,0.355159846083,0.173284952230,-0.170448319145,-0.075901461282,-0.134362316840,0.223164458707 &
            ,-0.373508064903,-0.060351473387,0.499832982143,-0.347836214288,-0.794799316689,1.208046834994,0.502970082636,-0.138411874958,-0.738787012320,-1.579956390206,0.318114072264,-0.391918271275 &
            ,-0.783351999491,0.175486783544,-0.158719943873,0.281642409933,0.736290385606,1.053875780033,-0.315797260135,0.273697767084,0.238475835176,-0.230117679023,0.067070606389,-0.391539517297 &
            ,-0.171331387811,1.075023376042,0.362969493896,0.399178692133,0.398517319066,0.754044032206,0.431590536668,-0.165951139278,-0.109049061608,-0.169808135075,-0.236897709306,-0.302163964246 &
            ,-0.115645106583,-0.431559476404,-0.204764300962,0.073870065849,-0.137728534245,-0.591086772179,0.238175928888,-0.432516422258,-0.970996689844,0.430267770412,-0.024776060392,0.007681557359 &
            ,4.706321830168,-0.109648586898,-1.559798266962,0.878359889525,-1.143870936639,-2.211689179932,3.608191927242,-2.516866022447,-2.601315861290,-1.942626142975,-2.563478058818,-8.464203235299 &
            ,-3.000726388510,0.728583271797,-1.347010588995,1.720745954714,-3.178668155074,1.957018690739,3.436228377161,3.017705669056,1.467653592394,2.552486185827,-0.840021508560,2.319112043696 &
            ,2.405248758372,-0.723104761633,0.757179349631,7.916411175305,8.198046943863,-1.487333272209,-1.269403769520,0.706223600970,-0.146312573315,3.233501995822,-1.797913041405,-2.048822942149 &
            ,-0.823481826970,-0.917036147394,3.357367892696,-2.413155237178,-0.367637742805,1.065921945946,-2.800078139957,-8.503242685840,-4.672004151130,2.777877736352,6.837185794016,-1.320858087656 &
            ,-1.169769525806,-1.799369171895,1.063699642629,-0.046512400976,-1.726840899955,-1.224209160064,-2.211114582306,2.501456340370,-3.536690478745,-3.239425929254,3.019357091945,2.909310119082 &
            ,0.543779543258,3.377018489744,-2.882052747537,0.478788312237,-1.143177676664,-3.106300325481,-0.590454565300,1.582451235062,0.915395070989,-3.342351148732,-4.882541633579,2.713955099096 &
            ,2.600191180779,2.880112477789,2.139290991601,2.171818166424,-1.446770923410,2.544348832806,-3.347893598574,5.343919068417,0.614778087749,1.063729538848,2.240332727925,1.647075942249 &
            ,-1.449311460143,3.566612838376,2.275194163333,-0.101528216084,-0.133517299865,0.379085986580,0.663898243929,1.313059357841,0.479989409653,1.141502114509,1.954586811958,0.757333427347 &
            ,-0.989875197161,0.205664475751,1.200073756984,0.762309650873,0.537999747236,-0.941452549714,0.753807061223,0.204572125979,-1.714844576573,-0.431755929664,-0.342105344992,0.917330138947 &
            ,-0.175823407270,-1.639207725685,0.275151508058,0.661242593705,-0.853101618414,-0.976826781129,-0.023379186775,2.102675920518,0.182536471112,-2.778527032820,-1.375691721001,1.855865870060 &
            ,-1.769345871740,-1.022457707103,0.006022589240,-0.011100060287,2.945658159749,-2.681294934685,-2.315754245414,1.455819607973,-2.868080546020,-0.470625669196,-3.358594876234,-1.171529079295 &
            ,4.749283766221,-1.014492887455,-0.625322869586,2.395972668977,-1.909770931959,2.372669225040,2.645187349674,2.788863633141,0.305298426940,1.205798081365,-2.119445953935,-2.263525904215 &
            ,0.569503068694,3.142199804663,0.444847401170,-1.270256285218,-1.795124084002,1.459067455994,1.114586654720,0.977704725374,1.448887354715,2.644328479784,-2.134708885782,-2.279590054521 &
            ,-1.353748232420,0.055786166900,6.811154909541,-3.149488219137,1.514560836971,0.557549043882,-0.351136990226,-0.628418684842,-0.219819432005,0.162392064451,1.934870012903,0.346377642477 &
            ,1.362830690731,0.316831694651,-3.025404131721,-0.230899998558,-0.714101050664,-3.660232100526,8.145621896179,-6.089015715611,-2.618011531823,-1.050643734991,2.674029791795,4.262415820293 &
            ,5.618169755105,1.977857453585,9.795700406941,3.707711020988,-3.488743779424,3.327653946984,0.331330777582,6.118578141309,10.548555636467,-1.303845320930,3.872870431485,-0.713721703379 &
            ,-4.916083124428,-0.553842904699,0.692816765238,1.517752783255,4.960783310945,2.773302785887,0.590178670714,1.698464579402,-5.916801509582,1.712654469368,0.806739994481,-1.623152364586 &
            ,1.672581511484,2.488850678329,5.779218630870,3.860982992231,0.227483411806,2.468213649314,-2.748823708109,-4.009048232750,-1.918405791202,5.721252703674,7.165028692611,-1.432835579000 &
            ,5.121964490387,-2.182698540134,-3.209160684456,0.902215062950,-7.121525733152,3.213191198765,2.143647941097,0.304380522730,5.700731545276,-2.096737638377,-2.572284811304,-1.529522784219 &
            ,-2.808124287083,0.881706066152,-2.801824308707,-0.878692626036,6.977617463410,0.164425478858,-3.511439318029,-3.438305009740,-2.384480377218,-0.147396853277,-3.734326910849,1.566871495184 &
            ,6.310428779494,2.149733339960,-2.672786201953,-3.288171100356,-1.558359088228,-0.400146463655,-4.893509077746,4.204476564706,4.002672421156,0.123239513572,-1.824428531673,0.494701028609 &
            ,-0.658597550040,-0.105628721941,-1.363870599400,-1.458156421682,1.615272695468,-0.603796650204,-0.723422352116,0.237614395637,-1.283812889480,0.482759442693,0.858151384302,-1.334658657834 &
            ,1.729931015967,0.120955242385,-0.272374961430,0.460992338175,1.070469702321,0.101651078385,4.879050674709,0.014979848979,0.286492983135,-0.741633562741,0.622226825241,0.257775749590 &
            ,-2.086757145989,0.648143439748,5.217310045174,-0.750514841365,0.690052032979,3.480041933644,-2.670460280365,-2.720810021752,-0.701844104159,-1.975406511356,0.368205161687,-2.079141667616 &
            ,-0.323039979028,0.770666533108,0.154948116090,0.580320701259,0.835776628546,-0.190465147917,-0.338778564618,0.260757354549,0.251692015728,0.721105851977,0.126261483412,0.179776630374 &
            ,0.069089432547,0.689432774020,0.212708228470,-0.373257173919,-0.878924173011,-1.860857666274,0.349794291451,-0.035493401558,-0.439455384649,-0.560626506847,-0.954210127796,0.832308888195 &
            ,0.763841353177,2.939256361930,-0.407259217027,-0.070752281710,0.389599625668,0.319676771633,0.487236234736,-0.708225940383,0.022597298367,-1.733495165259,0.179282502124,-0.149166952369 &
            ,-0.354714140471,0.340699420585,-0.840653824174,0.088273198962,0.642943117759,0.265346858418,-0.325271695103,-0.041907157238,-0.253591394712,-0.369262611639,-0.330319212747,-0.367056391783 &
            ,0.845836244709,1.568962574657,-0.481921849579,-0.661156835826,-0.462084668029,-0.200410206641,0.077156770607,-0.199384995988,-0.908271967553,-0.469706941609,0.588226919168,-0.076596526365 &
            ,-0.856458270728,-0.027751618635,-0.024148374682,0.228226205823,0.806373770001,0.285466291061,-0.398877370987,-0.148999083518,0.098733966567,-0.535146177642,-0.502197513147,-0.342528303152 &
            ,0.595029600126,1.158012664088,-0.073873294607,0.085976272341,0.485462657273,0.001909309473,0.755900369237,-0.981062796534,-0.511443759796,0.745663807060,0.350694970057,0.157871559950 &
            ,0.363790783738,0.355751801357,0.222955145668,0.084212506253,0.151279736457,1.562409822550,-0.025397626445,0.565746045925,1.189397238629,0.099627766906,0.134074247641,-0.190664941460 &
            ,0.170480663634,-0.252130187036,-0.091750522947,0.067074127004,0.027080018368,0.079812238627,0.651288209097,-0.729878065177,0.385398536993,1.615890726022,-0.158620541168,0.170781990957 &
            ,0.503882721240,0.107926763124,0.614473203083,-0.460514128444,-0.290125116238,-0.048842620020,0.212455056889,0.084264593616,0.013150258616,0.134286063679,0.164399648085,-0.062966459852 &
            ,-0.081423785359,-1.714630425912,0.110265013865,0.242410395274,-0.215553816438,-0.427027788388,-0.661234785308,0.093710977047,0.137368202809,-0.505853432047,-0.070474804911,-0.479693174632 &
            ,-0.491622805155,0.118706316114,0.243033900584,-0.191061043060,-0.105109592834,-0.574636494097,0.274747818525,0.562320889138,0.295433170662,-0.032401731844,-0.358094160258,0.201074734075 &
            ,-0.083811806375,0.640793404396,0.040573382760,-0.113511974264,-0.056486329238,0.096356650099,-0.103652559124,0.169683584712,-0.098201538115,-0.154165852413,0.072271134353,0.033287221883 &
            ,-0.054193700277,-0.015240698307,-0.055278602078,0.077251417200,0.210411862832,0.311845645673,-0.165713280363,-0.027920612858,0.076694878027,-0.088610735590,0.098403966565,-0.173777916108 &
            ,-0.092617635220,-0.521767685576,0.047740874370,-0.083397436472,-0.206300598316,0.026960656205,-0.010806201182,-0.003599343313,-0.157824038872,0.631801364875,0.111852077417,0.113080216082 &
            ,0.237728685920,0.175847951399,-0.076057556756,0.112999591138,0.040819720180,-0.205770407413,0.013733741270,0.098668565091,0.074338761741,-0.003767821184,-0.004346850383,-0.037188111136 &
            ,0.029961932895,-0.190618784988,-0.021415642522,-0.133419335477,-0.200063850531,-0.004215207604,-0.024664574130,0.020044186327,0.020241797944,0.653090719300,0.021178844683,0.097696789182 &
            ,0.211802410026,0.057324120488,-0.018236557360,0.074463285760,0.015201397742,0.025977821019,-0.005161420509,-0.135323241171,-0.184836720207,0.016101733073,0.051491867553,0.033107609724 &
            ,-0.392063804848,-0.152408163191,0.203706766849,0.129251959482,0.131547771989,0.083677170416,-0.270295436849,0.281561720677,0.088063225328,0.119776529934,-0.047586270042,-0.077159688036 &
            ,-0.045846839569,0.044764312446,0.012280803676,-0.028489862726,0.045419134500,-0.019699681984,-0.045165857807,-0.093387767896,-0.145862547923,-0.064750163385,0.005536307960,-0.002252305666 &
            ,-0.144575324930,0.166224271001,0.036938980095,-0.008296795557,-0.006693616843,-0.066640967512,-0.108576572755,0.137347338241,0.008495483569,0.076488660598,0.004470804921,0.031382769069 &
            ,-0.006855167959,-0.049367427449,-0.060143577826,0.056733011465,-0.156394045929,-0.137610078557,0.042227196547,0.013255679652,0.031667049380,-0.023605642385,-0.091102343322,0.085874027887 &
            ,-0.201403772818,-0.039164996654,0.083626402000,0.022145482842,0.036140269259,0.061122878425,-0.008604140338,0.063746453129,0.029043661954,-0.075077915570,-0.074261439054,-0.025749384779 &
            ,-0.006166793473,-0.101838801022,-0.064803604921,-0.016777680352,-0.097631736407,0.191765618973,0.017404307439,-0.017028056254,0.023119308591,0.023033372536,-0.106890255262,0.068175506048 &
            /),(/8,126/))
real, dimension(2,8) :: hidden1 = &
  Reshape((/-0.54676,-7.737 &
            ,-1.6776,-1.7751,0.15857,-25.3483 &
            ,0.17588,15.0242 &
            ,-1.124,-8.7763 &
            ,-1.9823,9.7069 &
            ,2.072,5.3226 &
            ,2.291,10.9932 &
            /),(/2,8/))
real, dimension(1,2) :: hidden2 = &
  Reshape((/0.067241,-6.221/),(/1,2/))
real, dimension(8) :: bias1 = &
  (/0.73999,-2.3748,-0.84983,-2.148,-4.475,-6.3818,-2.3283,-0.40998/)
real, dimension(2) :: bias2 = &
  (/-1.7453,3.8951/)
real, dimension(1) :: bias3 = &
  (/6.3209/)
contains
subroutine fnet_JP_initall()
end subroutine fnet_JP_initall
subroutine fnet_JP_engine(inarray, outarray, init)
  intrinsic MatMul, Size
  real, dimension(:), intent(in) :: inarray
  real, dimension(:), intent(inout) :: outarray
  real, dimension(126) :: inarray2
  real (kind=8), dimension(8) :: layer1
  real (kind=8), dimension(2) :: layer2
  real (kind=8), dimension(1) :: layer3
  integer , intent(inout) :: init
  integer :: i, j
  do i = 1, 126
    inarray2(i) = inarray(127-i)
  end do
  layer1 = MatMul(input,inarray2)
  layer1 = layer1 + bias1
  do i = 1, Size(layer1,1)
    layer1(i) = 1.0 / (1.0 + DEXP(-1.0 * layer1(i)))
  end do
  layer2 = MatMul(hidden1,layer1)
  layer2 = layer2 + bias2
  do i = 1, Size(layer2,1)
    layer2(i) = 1.0 / (1.0 + DEXP(-1.0 * layer2(i)))
  end do
  layer3 = MatMul(hidden2,layer2)
  layer3 = layer3 + bias3
  outarray(1) = layer3(1)
end subroutine fnet_JP_engine
end module fnet_JP