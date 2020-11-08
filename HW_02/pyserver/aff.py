import numpy as n
from sklearn.cluster import AffinityPropagation

sim_matrix = np.array(
        [[0.00039551693814875497, 0.0005781078510457991, 0.0009728019380395259, 0.0030357149131893892,
          0.0035388017205666496, 0.005415016331397109, 0.007481014170240459, 0.010925677406798473, 0.011473497636105614,
          0.011913180001907083, 0.02976521573887484, 0.03182854192207287],
         [0.0006569596351422458, 0.00039551693814875497, 0.033131301601765445, 0.035708009134795396, 0.5311125291329334,
          0.5764677566501927, 0.5779406281740996, 0.5786976860086921, 0.5788782755051001, 0.5791891089115877,
          0.5835814047114588, 0.6323331233780799],
         [0.00039551693814875497, 0.03055023737192868, 0.00039551693814875497, 0.03598593260777529, 0.05630211070996917,
          0.07673226076425188, 0.07961894147699744, 0.08071399691958174, 0.08098805882523401, 0.08160775760323732,
          0.0832781842423924, 0.09757348023429346],
         [0.00205155193309297, 0.003982579209051951, 0.008373997318720598, 0.00039551693814875497, 0.009839784475114275,
          0.021542665671022195, 0.43455491150875164, 0.5316918779074576, 0.5347932850871114, 0.542734410621406,
          0.547355301090847, 0.5558909699531307],
         [0.0004153663632673642, 0.33416771779341936, 0.35251139618657834, 0.35402952090647577, 0.00039551693814875497,
          0.3783605774574037, 0.379242132642813, 0.37970866866405667, 0.37982060567702514, 0.38001396082263883,
          0.38275838190458894, 0.4097391379211218],
         [0.001994834003122091, 0.04711947406010327, 0.0637843370967451, 0.07632617589812771, 0.10457031969161908,
          0.00039551693814875497, 0.11028026783990541, 0.1128674893139799, 0.11322425587046529, 0.11383499920309566,
          0.1415393319207409, 0.5586853680561685],
         [0.0020593504509494936, 0.003805039350526479, 0.007695565704599835, 0.4217430254592288, 0.4230796267777189,
          0.43306032042015924, 0.00039551693814875497, 0.5535938909685711, 0.5570781152662198, 0.5660811427467287,
          0.5703726883210887, 0.5778079280498339],
         [0.0034455399364165936, 0.004125058597046024, 0.0052116750336757105, 0.057145700878790465, 0.05769672152477093,
          0.06052635771858059, 0.22762794668638045, 0.00039551693814875497, 0.23736472528484165, 0.24923924355777932,
          0.2522759646227172, 0.2547020864729704],
         [0.0005549704160541244, 0.0007115127200398005, 0.0009871697336020252, 0.0032732754277419816,
          0.0034083092452886206, 0.0037929023945740665, 0.008162188163846871, 0.017895271133194637,
          0.00039551693814875497, 0.06511071983333548, 0.0654862793370385, 0.0658265395810626],
         [0.000438575479610495, 0.0007127944928724633, 0.001344295160424237, 0.007059026627391663, 0.007288090160782747,
          0.007963627005412807, 0.019286314719036114, 0.031111468813182917, 0.0780430232431597, 0.00039551693814875497,
          0.07850029433540208, 0.07906533408743445],
         [0.017799597933670815, 0.021701932923602698, 0.023368761059649967, 0.02868663738570669, 0.031922637504883625,
          0.05426439896308713, 0.05784638519949144, 0.06088988287150232, 0.06126426240666062, 0.06171526532343076,
          0.00039551693814875497, 0.09280840490959785],
         [0.0019495425022380435, 0.04612889126723066, 0.06418398247859544, 0.07763530876839547, 0.10516896350442759,
          0.519201821791369, 0.5252436650759313, 0.5279250728187082, 0.528290877917617, 0.5289179865199881,
          0.5547190272270955, 0.00039551693814875497]]
    )

aff = AffinityPropagation(damping = 0.5,max_iter = 3000)
aff.fit(sim_matrix)
labels = aff.labels_