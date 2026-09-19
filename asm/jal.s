.global _begin

_begin:
    jal  x1, fwd         
back:
    addi x6, x0, 2       
    jal  x0, done        
fwd:
    addi x5, x0, 1       
    jal  x0, back        
done:
    jal  x0, done        
