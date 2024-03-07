library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top is 
    generic (
            G_AXIL_DATA_WIDTH  : integer := 32; --Width of AXI Lite data bus
            G_AXI_ADDR_WIDTH   : integer := 32; --Width of AXI Lite Address Bu
            G_AXI_ID_WIDTH     : integer := 8; --Width of AXI ID Bus
            G_AXI_AWUSER_WIDTH : integer := 1 --Width of AXI AW User bus
        );
    port (
            --!System Inputs
            clk   : in std_logic;
            reset : in std_logic;
            --!External Interfaces
            rx : in std_logic;
            tx : out std_logic;

            --! AXIL Interface
            --!Write address
            axi_awaddr  : out std_logic_vector(G_AXI_ADDR_WIDTH - 1 downto 0);
            axi_awprot  : out std_logic_vector(2 downto 0);
            axi_awvalid : out std_logic;
            --!write data
            axi_wdata  : out std_logic_vector(G_AXIL_DATA_WIDTH - 1 downto 0);
            axi_wstrb  : out std_logic_vector(G_AXIL_DATA_WIDTH/8 - 1 downto 0);
            axi_wvalid : out std_logic;
            --!write response
            axi_bready : out std_logic;
            --!read address
            axi_araddr  : out std_logic_vector(G_AXI_ADDR_WIDTH - 1 downto 0);
            axi_arprot  : out std_logic_vector(2 downto 0);
            axi_arvalid : out std_logic;
            --!read data
            axi_rready : out std_logic;
            --write address
            axi_awready : in std_logic;
            --write data
            axi_wready : in std_logic;
            --write response
            axi_bresp  : in std_logic_vector(1 downto 0);
            axi_bvalid : in std_logic;
            --read address
            axi_arready : in std_logic;
            --read data
            axi_rdata  : in std_logic_vector(G_AXIL_DATA_WIDTH - 1 downto 0);
            axi_rresp  : in std_logic_vector(1 downto 0);
            axi_rvalid : in std_logic
);
end entity;

architecture rtl of top is

  signal m_axis_tready : std_logic;
  signal m_axis_tdata  : std_logic_vector(7 downto 0);
  signal m_axis_tvalid : std_logic;

  signal s_axis_tready : std_logic;
  signal s_axis_tdata  : std_logic_vector(7 downto 0);
  signal s_axis_tvalid : std_logic;
begin
  uart_inst : entity work.uart generic map
    (
    reset_level => '0', -- reset level which causes a reset
    clk_freq    => 100_000_000, -- oscillator frequency
    baud_rate   => 115200 -- baud rate
    )
    port map
    (
      --!System Inputs
      clk   => clk,
      reset => reset,
      --!External Interfaces
      rx => rx,
      tx => tx,
      --! Master AXIS Interface
      m_axis_tready => m_axis_tready,
      m_axis_tdata  => m_axis_tdata,
      m_axis_tvalid => m_axis_tvalid,
      --! Slave AXIS Interface
      s_axis_tready => s_axis_tready,
      s_axis_tdata  => s_axis_tdata,
      s_axis_tvalid => s_axis_tvalid
    );
  protocol_inst : entity work.axi_protocol 
    generic map
    (
        G_AXIL_DATA_WIDTH  => 32, --Width of AXI Lite data bus
        G_AXI_ADDR_WIDTH   => 32, --Width of AXI Lite Address Bu
        G_AXI_ID_WIDTH     => 8, --Width of AXI ID Bus
        G_AXI_AWUSER_WIDTH => 1 --Width of AXI AW User bus
    )
    port map
    (
        --Master clock & reset
        clk   => clk, --System clock
        reset => reset, --System reset, async active low
        --! Master AXIS Interface
        m_axis_tready => m_axis_tready,
        m_axis_tdata  => m_axis_tdata,
        m_axis_tvalid => m_axis_tvalid,
        --! Slave AXIS Interface
        s_axis_tready => s_axis_tready,
        s_axis_tdata  => s_axis_tdata,
        s_axis_tvalid => s_axis_tvalid,
        --! AXIL Interfa
        --!Write address
        axi_awaddr  => axi_awaddr ,
        axi_awprot  => axi_awprot ,
        axi_awvalid => axi_awvalid,
        --!write data
        axi_wdata  => axi_wdata,
        axi_wstrb  => axi_wstrb, 
        axi_wvalid => axi_wvalid,
        --!write response
        axi_bready => axi_bready,
        --!read address
        axi_araddr  => axi_araddr ,
        axi_arprot  => axi_arprot ,
        axi_arvalid => axi_arvalid,
        --!read data
        axi_rready => axi_rready,
        --write address
        axi_awready => axi_awready,
        --write data
        axi_wready => axi_wready,
        --write response
        axi_bresp  => axi_bresp ,
        axi_bvalid => axi_bvalid,
        --read address
        axi_arready => axi_arready,
        --read data
        axi_rdata  => axi_rdata ,
        axi_rresp  => axi_rresp ,
        axi_rvalid => axi_rvalid
    );


end architecture;