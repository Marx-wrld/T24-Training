SUBROUTINE BNR.INACTIVE.DORM.LOAD

$INSERT ../T24_BP I_COMMON
$INSERT ../T24_BP I_EQUATE
$INSERT ../T24_BP I_F.ACCOUNT
$INSERT ../T24_BP I_F.CUSTOMER
$INSERT ../T24_BP I_F.FUNDS.TRANSFER
$INSERT ../T24_BP I_F.OFS.SOURCE
$INSERT I_F.BNR.H.DORMANT.STATUS
$INSERT I_F.BNR.H.DORM.REGISTER
$INSERT I_F.BNR.H.DORMANCY.PARAM
$INSERT I_F.BNR.INACTIVE.DORM.COMMON
$INSERT ../T24_BP I_F.ACCOUNT.DEBIT.INT
$INSERT ../T24_BP I_F.ACCOUNT.CREDIT.INT

OPEN.FILES:
    F.ACCOUNT = ''
    FN.ACCOUNT = 'F.ACCOUNT'
    CALL OPF(FN.ACCOUNT, F.ACCOUNT)

    F.CUSTOMER = ''
    FN.CUSTOMER = 'F.CUSTOMER'
    CALL OPF(FN.CUSTOMER, F.REGISTER)

    FN.FUNDS.TRANSFER = 'F.FUNDS.TRANSFER'
    F.FUNDS.TRANSFER = ''
    CALL OPF(FN.FUNDS.TRANSFER, F.FUNDS.TRANSFER)

    F.ADI = ''
    F.ADI = 'F.ACCOUNT.DEBIT.INT'
    CALL OPF(FN.ADI, F.ADI)

    F.ACI = ''
    FN.ACI = 'F.ACCOUNT.CREDIT.INT'
    CALL OPF(FN.ACI, F.ACI)

    FN.OFS.SOURCE = 'F.OFS.SOURCE'
    F.OFS.SOURCE = ''
    CALL OPF(FN.OFS.SOURCE, F.OFS.SOURCE)

    F.DORM.PARAM = ''
    FN.DORM.PARAM = 'F.BNR.H.DORMANCY.PARAM'
    CALL OPF(FN.DORM.PARAM, F.DORM.PARAM)

    R.DORM.PARAM = '' ; PARAM.ERR = ''
    PARAM.ID = "SYSTEM"

    F.STMT.ENTRY = ''
    FN.STMT.ENTRY = 'F.STMT.ENTRY'
    CALL OPF(FN.STMT.ENTRY, F.STMT.ENTRY)

    F.ACCT.LWORK = ''
    FN.ACCT.LWORK = 'F.ACCT.ENT.LWORK.DAY'
    CALL OPF(FN.ACCT.LWORK, F.ACCT.LWORK)

LOAD:
    CALL F.READ(FN.DORM.PARAM, PARAM.ID, R.DORM.PARAM, F.DORM.PARAM, PARAM.ERR)

    IF R.DORM.PARAM THEN
        S.PARAM.CATEG = R.DORM.PARAM<BNR.CATEG.TO.INCLUDE>
        CHANGE VM TO ' ' IN S.PARAM.CATEG
        
        S.PARAM.EXCLUDE = R.DORM.PARAM<BNR.ACCT.TO.EXCLUDE>
        S.PARAM.SUSP = R.DORM.PARAM<BNR.BNR.PAYABLE.SUSP>
    END

    S.VALUE = "'NONE'"
    SEL.ADI = 'SSELECT ':FN.ADI:' WITH INTEREST.DAY.BASIS EQ ':S.VALUE

    S.ADI.LIST = '' ; NO.OF.RECS = '' ; ADI.ERR = ''
    CALL EB.READLIST(SEL.ADI.LIST.1,'',NO.OF.RECS, ADI.ERR)
    S.ADI = 'SSELECT ':FN.ACI:' WITH INTEREST.DAY.BASIS EQ ':S.VALUE
    S.ACI.LIST = '' ; NO.OF.RECS = '' ; ACI.ERR = ''
    CALL EB.READLIST(SEL.ACI.LIST.2, '',NO.OF.RECS,ACI.ERR)
    S.ACI.LIST = LIST.2

    RETURN
END