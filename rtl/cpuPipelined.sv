`timescale 1ns / 1ps
module cpuPipelined(
    input logic clk,
    input logic reset
);
    //============== Instruction Fetch (IF) ==============
    logic [31:0] pc; 
    logic [31:0] pcNext;
    logic [31:0] pcPlus4;
    
    logic [31:0] instrF;

    assign pcPlus4 = pc + 32'd4;

    logic pc_en, ifid_en, ifid_flush;

    PCReg u_pc(
        .clk(clk), .reset(reset),
        .en(pc_en),
        .pcNext(pcNext),
        .pc(pc)
    );
    instrMem u_imem(
        .pc(pc),
        .instruction(instrF)
    );

    //============== IF/ID pipeline register ==============
    logic [31:0] ifid_pc;
    logic [31:0] ifid_pc4;
    logic [31:0] ifid_instr;

    IF_ID u_ifid(
        .clk(clk),
        .reset(reset),
        .en(ifid_en),
        .flush(ifid_flush),
        .pc_in(pc),
        .pc4_in(pcPlus4),
        .instr_in(instrF),
        .pc_out(ifid_pc),
        .pc4_out(ifid_pc4),
        .instr_out(ifid_instr)
    );

    //============== Instruction Decode (ID) ==============
    logic [6:0] opcodeD;
    logic [4:0] rs1D;
    logic [4:0] rs2D;
    logic [4:0] rdD;
    logic [2:0] funct3D;
    logic [6:0] funct7D;

    assign opcodeD = ifid_instr[6:0];
    assign rdD = ifid_instr[11:7];
    assign funct3D = ifid_instr[14:12];
    assign rs1D = ifid_instr[19:15];
    assign rs2D = ifid_instr[24:20];
    assign funct7D = ifid_instr[31:25];

    //Control logic
    logic regWriteD;
    logic aluSrcD;
    logic memWriteD;
    logic memReadD;
    logic memToRegD;
    logic branchD;
    logic jumpD;
    logic jalrD;
    logic [3:0] aluOpCatD;

    logic [1:0] immSelD;

    controlUnit u_ctrl(
        .opcode(opcodeD),
        .regWrite(regWriteD),
        .aluSrc(aluSrcD),
        .memWrite(memWriteD),
        .memRead(memReadD),
        .memToReg(memToRegD),
        .branch(branchD),
        .jump(jumpD),
        .jalr(jalrD),
        .aluOp(aluOpCatD),
        .immSel(immSelD)
    );

    //Immediates
    logic [31:0] immI_D;
    logic [31:0] immS_D;
    logic [31:0] immB_D;
    logic [31:0] immJ_D;
    
    immGen u_imm(
        .instr(ifid_instr),
        .immI(immI_D),
        .immS(immS_D), 
        .immB(immB_D), 
        .immJ(immJ_D)
    );

    //WB -> regfile wires
    logic regWriteW;
    logic [4:0]  rdW;
    logic [31:0] wdW;

    //Regfile
    logic [31:0] ro1D, ro2D;
    regFilSV u_rf(
        .clk(clk),
        .reset(reset),
        .we(regWriteW),
        .regAdd1(rs1D),
        .regAdd2(rs2D),
        .rd(rdW),
        .wd(wdW),
        .ro1(ro1D),
        .ro2(ro2D)
    );

    //Hazard detect, ID regs and EX load info
    logic idex_memRead;
    logic [4:0] idex_rd;
    logic idex_flush_hazard;

    hazardUnit u_haz(
        .ex_memRead(idex_memRead),
        .ex_rd(idex_rd),
        .id_rs1(rs1D),
        .id_rs2(rs2D),
        .pc_en(pc_en),
        .ifid_en(ifid_en),
        .idex_flush(idex_flush_hazard)
    );

    //============== ID/EX pipline register ==============
    logic idex_regWrite;
    logic idex_aluSrc;
    logic idex_memWrite;
    logic idex_memToReg;
    logic idex_branch;
    logic idex_jump;
    logic idex_jalr;
    
    logic [1:0] idex_immSel;
    
    logic [3:0] idex_aluOpCat;
    logic [31:0] idex_pc;
    logic [31:0] idex_pc4;
    logic [31:0] idex_r1;
    logic [31:0] idex_r2;
    logic [31:0] idex_immI;
    logic [31:0] idex_immS;
    logic [31:0] idex_immB;
    logic [31:0] idex_immJ;
    
    logic [2:0]  idex_funct3;
    logic [6:0]  idex_funct7;
    logic [4:0]  idex_rs1, idex_rs2;

    logic idex_flush;

    ID_EX u_idex(
        .clk(clk), 
        .reset(reset), 
        .flush(idex_flush),

        .regWrite_in(regWriteD),
        .aluSrc_in(aluSrcD),
        .memWrite_in(memWriteD),
        .memRead_in(memReadD),
        .memToReg_in(memToRegD),
        .branch_in(branchD),
        .jump_in(jumpD),
        .jalr_in(jalrD),
        .aluOpCat_in(aluOpCatD),
        .immSel_in(immSelD), 
        
        .pc_in(ifid_pc),
        .pc4_in(ifid_pc4),
        .r1_in(ro1D),
        .r2_in(ro2D),
        .immI_in(immI_D),
        .immS_in(immS_D),
        .immB_in(immB_D),
        .immJ_in(immJ_D),
        .funct3_in(funct3D),
        .funct7_in(funct7D),
        .rs1_in(rs1D),
        .rs2_in(rs2D),
        .rd_in(rdD),

        .regWrite_out(idex_regWrite),
        .aluSrc_out(idex_aluSrc),
        .memWrite_out(idex_memWrite),
        .memRead_out(idex_memRead),
        .memToReg_out(idex_memToReg),
        .branch_out(idex_branch),
        .jump_out(idex_jump),
        .jalr_out(idex_jalr),
        .aluOpCat_out(idex_aluOpCat),
        .immSel_out(idex_immSel),

        .pc_out(idex_pc),
        .pc4_out(idex_pc4),
        .r1_out(idex_r1),
        .r2_out(idex_r2),
        .immI_out(idex_immI),
        .immS_out(idex_immS),
        .immB_out(idex_immB),
        .immJ_out(idex_immJ),
        .funct3_out(idex_funct3),
        .funct7_out(idex_funct7),
        .rs1_out(idex_rs1),
        .rs2_out(idex_rs2),
        .rd_out(idex_rd)
    );

    //============== Execution (EX) ==============
    //Forwarding stuff
    logic [1:0] fwdA;
    logic [1:0] fwdB;

    logic [4:0] exmem_rd;
    logic [4:0] memwb_rd;
    logic exmem_regWrite;
    logic memwb_regWrite;

    forwardUnit u_fwd(
        .ex_rs1(idex_rs1),
        .ex_rs2(idex_rs2),
        .mem_rd(exmem_rd),
        .mem_regWrite(exmem_regWrite),
        .wb_rd(memwb_rd),
        .wb_regWrite(memwb_regWrite),
        .fwdA(fwdA),
        .fwdB(fwdB)
    );

    //Values for forwarding
    logic [31:0] exmem_aluY;
    logic [31:0] memwb_aluY;
    logic [31:0] memwb_mem;
    logic [31:0] exmem_pc4;
    logic [31:0] memwb_pc4;
    logic exmem_memToReg;
    logic memwb_memToReg;
    logic exmem_wbFromPC4;
    logic memwb_wbFromPC4;

    //computations for forwarding
    logic [31:0] wbData_internal;
    always_comb begin
        if (memwb_wbFromPC4)
            wbData_internal = memwb_pc4;
        else if (memwb_memToReg)  
            wbData_internal = memwb_mem;
        else                      
            wbData_internal = memwb_aluY;
    end

    //muxes for forwarding
    logic [31:0] exA, exB;
    always_comb begin
        unique case (fwdA)
            2'b00: exA = idex_r1;
            2'b10: exA = exmem_aluY;
            2'b01: exA = wbData_internal;
            default: exA = idex_r1;
        endcase

        unique case (fwdB)
            2'b00: exB = idex_r2;
            2'b10: exB = exmem_aluY;
            2'b01: exB = wbData_internal;
            default: exB = idex_r2;
        endcase
    end

    //ALU operation decode
    logic [3:0] aluOpEX;
    aluControl u_aluctrl(
        .aluOpCat(idex_aluOpCat),
        .funct3(idex_funct3),
        .funct7(idex_funct7),
        .aluOpOut(aluOpEX)
    );
    
    logic [31:0] immEX;
    always_comb begin
        unique case (idex_immSel)
            2'b00: immEX = idex_immI; 
            2'b01: immEX = idex_immS;
            default: immEX = idex_immI;
        endcase
    end
    
    //ALU B operand mux
    logic [31:0] aluB;
    assign aluB = idex_aluSrc ? immEX : exB;

    //ALU
    logic [31:0] aluY_EX;
    logic zeroEX;
    logic ovEX;
    logic cEX;
    logic negEX;

    ALU u_alu(
        .A(exA), 
        .B(aluB), 
        .aluOp(aluOpEX),
        .Y(aluY_EX), 
        .zero(zeroEX), 
        .overflow(ovEX), 
        .carry(cEX), 
        .negative(negEX)
    );

    //Branch/jump things needed to propagate in EX
    logic branchTaken;
    logic [31:0] branchTarget;
    logic [31:0] jalTarget;
    logic [31:0] jalrTarget;

    assign branchTarget = idex_pc + idex_immB;
    assign jalTarget = idex_pc + idex_immJ;
    assign jalrTarget = (exA + idex_immI) & 32'hFFFF_FFFE;

    assign branchTaken  = idex_branch && zeroEX; //handles BEQ

    logic controlTaken;
    always_comb begin
        controlTaken = 1'b0;
        pcNext = pcPlus4;

        if (branchTaken) begin
            controlTaken = 1'b1;
            pcNext = branchTarget;
        end
        if (idex_jump) begin
            controlTaken = 1'b1;
            pcNext = jalTarget;
        end
        if (idex_jalr) begin
            controlTaken = 1'b1;
            pcNext = jalrTarget;
        end
    end

    assign ifid_flush = controlTaken;
    assign idex_flush = idex_flush_hazard | controlTaken;

    //For jal/jalr WB is PC+4
    logic wbFromPC4_EX;
    assign wbFromPC4_EX = idex_jump | idex_jalr;

    //Store data uses forwarded exB
    logic [31:0] storeData_EX;
    assign storeData_EX = exB;

    //============== EX/MEM pipline register ==============
    logic exmem_memWrite;
    logic exmem_memRead;
    logic [31:0] exmem_store;

    EX_MEM u_exmem(
        .clk(clk), 
        .reset(reset),

        .regWrite_in(idex_regWrite),
        .memWrite_in(idex_memWrite),
        .memRead_in(idex_memRead),
        .memToReg_in(idex_memToReg),
        .wbFromPC4_in(wbFromPC4_EX),

        .pc4_in(idex_pc4),
        .aluY_in(aluY_EX),
        .store_in(storeData_EX),
        .rd_in(idex_rd),

        .regWrite_out(exmem_regWrite),
        .memWrite_out(exmem_memWrite),
        .memRead_out(exmem_memRead),
        .memToReg_out(exmem_memToReg),
        .wbFromPC4_out(exmem_wbFromPC4),

        .pc4_out(exmem_pc4),
        .aluY_out(exmem_aluY),
        .store_out(exmem_store),
        .rd_out(exmem_rd)
    );

    // ============== Memory (MEM) ==============
    logic [31:0] memData_M;
    dataMem u_dmem(
        .clk(clk),
        .memRead(exmem_memRead),
        .memWrite(exmem_memWrite),
        .addr(exmem_aluY),
        .wdata(exmem_store),
        .rdata(memData_M)
    );

    // ============== MEM/WB pipeline register ==============
    MEM_WB u_memwb(
        .clk(clk), .reset(reset),

        .regWrite_in(exmem_regWrite),
        .memToReg_in(exmem_memToReg),
        .wbFromPC4_in(exmem_wbFromPC4),

        .pc4_in(exmem_pc4),
        .aluY_in(exmem_aluY),
        .mem_in(memData_M),
        .rd_in(exmem_rd),

        .regWrite_out(memwb_regWrite),
        .memToReg_out(memwb_memToReg),
        .wbFromPC4_out(memwb_wbFromPC4),

        .pc4_out(memwb_pc4),
        .aluY_out(memwb_aluY),
        .mem_out(memwb_mem),
        .rd_out(memwb_rd)
    );

    // ============== WB ==============
    assign regWriteW = memwb_regWrite;
    assign rdW = memwb_rd;

    always_comb begin
        if (memwb_wbFromPC4)      
            wdW = memwb_pc4;
        else if (memwb_memToReg)  
            wdW = memwb_mem;
        else                      
            wdW = memwb_aluY;
    end

endmodule