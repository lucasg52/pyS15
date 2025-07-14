
ctypedef unsigned int uint32  
ctypedef unsigned long long uint64 
ctypedef unsigned short eventcount_t
ctypedef unsigned int coinccount_t

cdef struct CoincVec:
    coinccount_t coinc3
    coinccount_t paircnt_1_3
    coinccount_t paircnt_1_4
    coinccount_t gatecnt
    # coinccount_t paircnt_3_4
# 
# cdef CoincVec get_windowcoincs(eventcount_t[4] counts, int idx):
#     if idx == 0:
# 
#     return (0,0,0,0)
# 
# cdef int get_window3coincs():
#     return 0


# cpdef int count_3coinc(uint64[:] ts, uint32[:] ps, int coincw_ns):
#     cdef int i, j, total = 0, length = len(ts)
#     cdef uint64 t
#     cdef uint32 p
#     cdef uint64 cutoff
#     cdef int[4] ch_counts = [0, 0, 0, 0]
#     cdef uint64[64] tsqueue
#     cdef uint32[64] psqueue
#     cdef int i_qf = 0 # queue front index
#     cdef int i_qt = 0 # queue tail index
#     for j in range(length):
#         t = ts[j]
#         p = ps[j]
#         cutoff = t - coincw_ns
#         while (i_qf - i_qt > 0 and tsqueue[i_qt] 
# 

cpdef CoincVec count_3coinc(uint64[:] ts, uint32[:] ps, int coincw_ns):
    cdef int i, j, length = len(ts)
    cdef CoincVec totals = CoincVec(0,0,0,0)
    cdef uint64 t
    cdef uint32 p
    cdef uint64 cutoff
    cdef eventcount_t[4] ch_counts = [0, 0, 0, 0]
    cdef int j_t = 0 # queue tail index
    for j in range(length):
        t = ts[j]

        # flush all invalid events
        if t >= coincw_ns:
            cutoff = t + 1 - coincw_ns
        else:
            cutoff = 0
        while (j_t < j and ts[j_t] < cutoff):
            p = ps[j_t]
            j_t += 1
            for i in range(4):
                if i != 1 and (p & (1 << i) != 0):
                    ch_counts[i] -= 1
        # count coincidences
        p = ps[j]
        for i in range(4):
            if i != 1 and (p & (1 << i) != 0):
                if i == 0:
                    totals.gatecnt += 1
                    totals.paircnt_1_3 += ch_counts[2]
                    totals.paircnt_1_4 += ch_counts[3]
                    totals.coinc3 += ch_counts[2] * ch_counts[3]
                if i == 2:
                    totals.paircnt_1_3 += ch_counts[0]
                    totals.coinc3 += ch_counts[0] * ch_counts[3]
                if i == 3:
                    totals.paircnt_1_4 += ch_counts[0]
                    totals.coinc3 += ch_counts[0] * ch_counts[2]
                ch_counts[i] += 1
            #
        #
    #
    return totals

