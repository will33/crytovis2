class Constants {

  /// The electricity price of each country, in kW/Hs. Sourced from Statista,
  /// current as of September 2020. https://www.statista.com/aboutus/trust
  static const ELECTRICITY_PRICES = {
    'Australia': 0.32,
    'Argentina': 0.077,
    'Belgium': 0.39,
    'Brazil': 0.15,
    'China': 0.1,
    'Cyprus': 0.27,
    'Denmark': 0.42,
    'France': 0.28,
    'Germany': 0.46,
    'India': 0.1,
    'Indonesia': 0.13,
    'Iran': 0.013,
    'Ireland': 0.35,
    'Italy': 0.33,
    'Kenya': 0.27,
    'Japan': 0.33,
    'Mexico': 0.1,
    'New Zealand': 0.31,
    'Nigeria': 0.077,
    'Poland': 0.24,
    'Portugal': 0.35,
    'Qatar': 0.039,
    'Russia': 0.077,
    'Rwanda': 0.33,
    'Saudi Arabia': 0.064,
    'Singapore': 0.21,
    'South Africa': 0.19,
    'Spain': 0.31,
    'Turkey': 0.12,
    'UK': 0.33,
    'USA': 0.19,
  };

  static const PROCESSOR_TYPES = ['ASIC', 'GPU', 'CPU'];
  static const PROCESSORS = {
    'ASIC': [
      // Original hardware
      'AntMiner', 'AC130', 'SPS320',
      // Hardware taken from research (cointopper.com)
      'AntMiner S2', 'AntMiner S4', 'AntMiner S5', 'ASICMiner BE Prisma',
      'BFL Monarch', 'Black Arrow Prospero X-3', 'CoinTera TerraMiner IV',
      'HashCoins Apollo V3', 'HashCoins Zeus v3', 'KnC Neptune',
      'Spondooliestech SP10', 'Spondooliestech SP35'
    ],
    'GPU': [
      // Original hardware
      'GTX 1080 Ti', 'RTX 2070S', 'RX 480',
      // Hardware taken from research (cointopper.com)
      'AMD 4870', 'AMD 5770', 'AMD 5830', 'AMD 5850', 'AMD 5870', 'AMD 5970',
      'AMD 6990', 'NVIDIA GT-210', 'NVIDIA GTX-280', 'NVIDIA GTX-480',
      'NVIDIA Tesla S1070', 'NVIDIA Tesla S2070'
    ],
    'CPU': [
      // Original hardware
      'i7 7700k', 'i5 3750k', '5700X',
      // Hardware taken from research (cointopper.com)
      'Athlon 64 X2 5600+', 'Athlon II X3 425', 'Phenom II X4 955', 'FX-8120',
      'FX-8350', 'Core 2 Quad Q6600', 'Core 2 Quad Q9550', 'Core i3-2130',
      'Core i5-2500K', 'Core i5-3570K', 'Core i7-3930K'
    ]
  };

  /// The initial capital expense associated with each processor.
  /// Values currently taken from Google
  static const INITIAL_CAPITALS = {
    // ASIC
    'AntMiner': 1000,
    'AC130': 1000,
    'SPS320': 1000,

    'AntMiner S2': 2259,
    'AntMiner S4': 1400,
    'AntMiner S5': 550,
    'ASICMiner BE Prisma': 600,
    'BFL Monarch': 1379,
    'Black Arrow Prospero X-3': 899,
    'CoinTera TerraMiner IV': 5999,
    'HashCoins Apollo V3': 599,
    'HashCoins Zeus v3': 2299,
    'KnC Neptune': 120,
    'Spondooliestech SP10': 489,
    'Spondooliestech SP35': 2000,

    // GPU
    'GTX 1080 Ti': 1000,
    'RTX 2070S': 1000,
    'RX 480': 1000,

    'AMD 4870': 299,
    'AMD 5770': 149,
    'AMD 5830': 299,
    'AMD 5850': 259,
    'AMD 5870': 379,
    'AMD 5970': 249,
    'AMD 6990': 699,
    'NVIDIA GT-210': 56,
    'NVIDIA GTX-280': 135,
    'NVIDIA GTX-480': 499,
    'NVIDIA Tesla S1070': 400,
    'NVIDIA Tesla S2070': 18995,

    // CPU
    'i7 7700k': 1000,
    'i5 3750k': 1000,
    '5700X': 1000,

    'Athlon 64 X2 5600+': 110,
    'Athlon II X3 425': 31,
    'Phenom II X4 955': 88,
    'FX-8120': 120,
    'FX-8350': 195,
    'Core 2 Quad Q6600': 15,
    'Core 2 Quad Q9550': 60,
    'Core i3-2130': 102,
    'Core i5-2500K': 289,
    'Core i5-3570K': 235,
    'Core i7-3930K': 594
  };

  /// The power usage of each processor, in Watts.
  /// Values from cointopper.com
  static const POWER_USAGES = {
    // ASIC
    'AntMiner': 1000,
    'AC130': 800,
    'SPS320': 900,

    'AntMiner S2': 1100,
    'AntMiner S4': 1400,
    'AntMiner S5': 590,
    'ASICMiner BE Prisma': 1100,
    'BFL Monarch': 490,
    'Black Arrow Prospero X-3': 2000,
    'CoinTera TerraMiner IV': 2100,
    'HashCoins Apollo V3': 1000,
    'HashCoins Zeus v3': 3000,
    'KnC Neptune': 2100,
    'Spondooliestech SP10': 1250,
    'Spondooliestech SP35': 2650,

    // GPU
    'GTX 1080 Ti': 500,
    'RTX 2070S': 400,
    'RX 480': 300,

    'AMD 4870': 150,
    'AMD 5770': 100,
    'AMD 5830': 125,
    'AMD 5850': 180,
    'AMD 5870': 200,
    'AMD 5970': 350,
    'AMD 6990': 400,
    'NVIDIA GT-210': 30,
    'NVIDIA GTX-280': 230,
    'NVIDIA GTX-480': 250,
    'NVIDIA Tesla S1070': 800,
    'NVIDIA Tesla S2070': 900,

    // CPU
    'i7 7700k': 180,
    'i5 3750k': 100,
    '5700X': 200,

    'Athlon 64 X2 5600+': 89,
    'Athlon II X3 425': 125,
    'Phenom II X4 955': 125,
    'FX-8120': 125,
    'FX-8350': 125,
    'Core 2 Quad Q6600': 100,
    'Core 2 Quad Q9550': 125,
    'Core i3-2130': 65,
    'Core i5-2500K': 90,
    'Core i5-3570K': 90,
    'Core i7-3930K': 200
  };

  static const int HOURS_IN_DAY = 24;
  static const int WATTS_IN_KILOWATT = 1000;

  /// The hash rate of each processor in MH/s
  /// Values from cointopper.com
  static const HASH_RATES = {
    // ASIC
    'AntMiner': 700,
    'AC130': 800,
    'SPS320': 900,

    'AntMiner S2': 1000000,
    'AntMiner S4': 2000000,
    'AntMiner S5': 1155000,
    'ASICMiner BE Prisma': 1400000,
    'BFL Monarch': 700000,
    'Black Arrow Prospero X-3': 2000000,
    'CoinTera TerraMiner IV': 1600000,
    'HashCoins Apollo V3': 1100000,
    'HashCoins Zeus v3': 4500000,
    'KnC Neptune': 3000000,
    'Spondooliestech SP10': 1400000,
    'Spondooliestech SP35': 5500000,

    // GPU
    'GTX 1080 Ti': 45.69,
    'RTX 2070S': 43,
    'RX 480': 30.29,

    'AMD 4870': 90,
    'AMD 5770': 240,
    'AMD 5830': 300,
    'AMD 5850': 400,
    'AMD 5870': 480,
    'AMD 5970': 800,
    'AMD 6990': 800,
    'NVIDIA GT-210': 4,
    'NVIDIA GTX-280': 60,
    'NVIDIA GTX-480': 140,
    'NVIDIA Tesla S1070': 155,
    'NVIDIA Tesla S2070': 750,

    // CPU
    'i7 7700k': 5,
    'i5 3750k': 4,
    '5700X': 6,

    'Athlon 64 X2 5600+': 6.07 * 0.001,
    'Athlon II X3 425': 9.5 * 0.001,
    'Phenom II X4 955': 22 * 0.001,
    'FX-8120': 46 * 0.001,
    'FX-8350': 65 * 0.001,
    'Core 2 Quad Q6600': 9.68 * 0.001,
    'Core 2 Quad Q9550': 32.2 * 0.001,
    'Core i3-2130': 23 * 0.001,
    'Core i5-2500K': 48 * 0.001,
    'Core i5-3570K': 55 * 0.001,
    'Core i7-3930K': 98 * 0.001
  };

  static const NETWORK_HASHRATE = 149045000; // TODO: Make this variable per day
  static const BITCOIN_BLOCK_REWARD = 6.25;
  static const BITCOIN_AVG_BLOCKTIME = 10;
  static const MINUTES_IN_DAY = 1440;
  static const DAYS_IN_TWO_YEARS = 1825;
}
