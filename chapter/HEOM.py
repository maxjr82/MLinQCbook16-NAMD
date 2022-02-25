import numpy as np
from qutip import sigmax, sigmay, sigmaz, basis, expect
from qutip.nonmarkov.heom import HSolverDL
import time

start_time = time.time()
eps = 1.0  # bias
Del = 1.0  # Delta
Hsys = eps * sigmaz() + Del*sigmax()

temperature = 1.0
Nk = 5    # this factor is represented as K in the chapter 
Ncut = 50  # this factor is represented as L in the chapter
Q = sigmaz()  
gam = 1.0  # wc - cutoff frequency
lam = 1.0  # lambda

hsolver = HSolverDL(Hsys, Q, lam, temperature, Ncut, Nk, gam, stats=True)

rho0 = basis(2,0) * basis(2,0).dag()

tlist = np.linspace(0,20, 401)

result = hsolver.run(rho0, tlist)
hsolver.stats.report()

P11p = basis(2,0) * basis(2,0).dag()
P22p = basis(2,1) * basis(2,1).dag()

P11exp = expect(result.states, P11p)
P22exp = expect(result.states, P22p)

data = np.column_stack((tlist, np.real(P11exp), np.real(P22exp), np.real(P11exp) - np.real(P22exp)))

filename = "P_wda-" + str(eps) + "_gda-" + str(Del) + "_lambda-" + str(lam) + "_wc-" + str(gam) + "_beta-" + str(beta) + ".dat"
np.savetxt(filename, data)

print("--- %s seconds ---" % (time.time() - start_time))
