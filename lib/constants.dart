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
    'ASIC': ['AntMiner', 'AC130', 'SPS320'],
    'GPU': ['GTX 1080 Ti', 'RTX 2070S', 'RX 480'],
    'CPU': ['i7 7700k', 'i5 3750k', '5700X']
  };
  /// The power usage of each processor, in Watts.
  static const POWER_USAGES = {
    'AntMiner': 1000,
    'AC130': 800,
    'SPS320': 900,
    'GTX 1080 Ti': 500,
    'RTX 2070S': 400,
    'RX 480': 300,
    'i7 7700k': 180,
    'i5 3750k': 100,
    '5700X': 200
  };
  static const int HOURS_IN_DAY = 24;
  static const int WATTS_IN_KILOWATT = 1000;
  /// The hash rate of each processor in MH/s
  static const HASH_RATES = {
  'AntMiner': 700,
  'AC130': 800,
  'SPS320': 900,
  'GTX 1080 Ti': 45.69,
  'RTX 2070S': 43,
  'RX 480': 30.29,
  'i7 7700k': 5,
  'i5 3750k': 4,
  '5700X': 6
  };
  static const NETWORK_HASHRATE = 149045000;
  static const BITCOIN_BLOCK_REWARD = 6.25;
  static const BITCOIN_AVG_BLOCKTIME = 10;
  static const MINUTES_IN_DAY = 1440;
}