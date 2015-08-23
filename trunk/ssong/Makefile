ORAINC=-I${ORACLE_HOME}/precomp/public \
       -I${ORACLE_HOME}/rdbms/public
ORALIB=${ORACLE_HOME}/lib
PROCFLAGS=SQLCHECK=SEMANTICS \
          userid=student/111111@210.30.98.114:2003/dbdesign.zxc-pc
CFLAGS=$(ORAINC)
TARGET=ssong
OBJ=ssong.o

.SUFFIXES: .o .c .pc
.pc.c:
	proc $(PROCFLAGS) $<
.c.o:
	gcc $(CFLAGS) -c $<

$(TARGET): $(OBJ)
	gcc $(OBJ) -o $(TARGET) -L$(ORALIB) -lclntsh

.PHONY: clean
clean:
	rm -f *.o *.lis
