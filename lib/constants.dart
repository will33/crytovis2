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

  /// List of processors of format [processor]: [Cost, Power, SHA256, Ethash, RandomX]
  static const PROCESSORS = {
    // Price data from Amazon, Cryptocompare.com and various other online 
    // sources (converted to AUD on 09/05/2021), other data from nicehash.com
    'ASIC': {
      'BITMAIN AntMiner S19 Pro': [22933, 3250, 110000000, 0, 0, 0],
      'BITMAIN AntMiner S19': [20830, 3250, 95000000, 0, 0, 0],
      'BITMAIN AntMiner S17 Pro': [15971, 1975, 84000000, 0, 0, 0],
      'BITMAIN AntMiner S17+': [15925, 2920, 80000000, 0, 0, 0],
      'BITMAIN AntMiner S17': [3187, 2385, 85000000, 0, 0, 0],
      'BITMAIN AntMine S17e': [1019, 2880, 64000000, 0, 0, 0],
      'BITMAIN AntMiner T17+': [2410, 3200, 73000000, 0, 0, 0],
      'BITMAIN AntMiner T17': [876, 2200, 60000000, 0, 0, 0],
      'BITMAIN AntMiner T17e': [887, 2915, 53000000, 0, 0, 0],
      'Innosilicon T3+ 57T': [2124, 3300, 57000000, 0, 0],
      'MicroBT Whatsminer M31S': [2486, 3220, 70000000, 0, 0, 0],
      'MicroBT Whatsminer M30S': [3436, 3268, 86000000, 0, 0, 0],
      'MicroBT Whatsminer M21S': [2293, 3360, 56000000, 0, 0, 0],
      'MicroBT Whatsminer M20S': [2952, 3360, 68000000, 0, 0, 0],
      'MicroBT Whatsminer M10S': [2558, 3500, 55000000, 0, 0, 0],
    },
    'GPU': {
      'AMD Radeon VII': [0, 220, 0, 90.56, 0, 0.0017],
      'AMD RX 6900 XT': [0, 220, 0, 64, 0, 0],
      'AMD RX 6800 XT': [0, 190, 0, 64.4, 0, 0],
      'AMD RX 6800': [0, 175, 0, 63.4, 0, 0],
      'AMD RX 6700 XT': [0, 170, 0, 47, 0, 0],
      'AMD RX 5700 XT': [0, 140, 0, 54.76, 0, 0],
      'AMD RX 5700': [0, 160, 0, 53.56, 0, 0],
      'AMD RX 5600 XT': [0, 100, 0, 37, 0, 0],
      'NVIDIA A100': [0, 210, 0, 171, 0, 0],
      'NVIDIA P102-100': [0, 190, 0, 47.56, 0, 0],
      'NVIDIA P104-100': [0, 120, 0, 37, 0, 0],
      'NVIDIA RTX 3090': [0, 285, 0, 120, 0, 0],
      'NVIDIA RTX 3080': [0, 220, 0, 96, 0, 0],
      'NVIDIA RTX 3070': [0, 120, 0, 29.53, 0, 0],
      'NVIDIA RTX 3060 Ti': [0, 115, 0, 60.5, 0, 0],
      'NVIDIA RTX 3060': [0, 115, 0, 49, 0, 0],
      'NVIDIA RTX 2080 Ti': [0, 230, 0, 59.21, 0, 0],
      'NVIDIA RTX 2080': [0, 108, 0, 43, 0, 0],
      'NVIDIA RTX 2070': [0, 110, 0, 42.7, 0, 0],
      'NVIDIA GTX 1080 Ti': [0, 170, 0, 45.69, 0, 0.0009],
      'NVIDIA TITAN V': [0, 160, 0, 78.2, 0, 0],
      'NVIDIA TITAN RTX': [0, 250, 0, 66, 0, 0],
      'NVIDIA TITAN XP': [0, 240, 0, 45.49, 0, 0],
    },
    'CPU': {
      'AMD EPYC 7742': [0, 225, 0, 0, 0, 0.039],
      'AMD EPYC 7601': [0, 180, 0, 0, 0, 0.0283],
      'AMD EPYC 7551': [0, 180, 0, 0, 0, 0.0289],
      'AMD EPYC 7402P': [0, 200, 0, 0, 0, 0.023],
      'AMD EPYC 7402': [0, 200, 0, 0, 0, 0.023],
      'AMD EPYC 7352': [0, 155, 0, 0, 0, 0.0215],
      'AMD EPYC 7302': [0, 155, 0, 0, 0, 0.0244],
      'AMD Threadripper 3990X': [0, 280, 0, 0, 0, 0.053],
      'AMD Threadripper 3970X': [0, 280, 0, 0, 0, 0.032],
      'AMD Threadripper 3960X': [0, 280, 0, 0, 0, 0.0268],
      'AMD Threadripper 2990WX': [0, 250, 0, 0, 0, 0.1451],
      'AMD Ryzen 9 5950X': [0, 105, 0, 0, 0, 0.018],
      'AMD Ryzen 9 5900X': [0, 105, 0, 0, 0, 0.014],
      'AMD Ryzen 9 3950X': [0, 105, 0, 0, 0, 0.01651],
      'AMD Ryzen 9 3900XT': [0, 105, 0, 0, 0, 0.0131],
      'AMD Ryzen 9 3900X': [0, 105, 0, 0, 0, 0.01317],
      'AMD Ryzen 7 5800X': [0, 105, 0, 0, 0, 0.010],
      'AMD Ryzen 7 3800X': [0, 105, 0, 0, 0, 0.0092],
      'AMD Ryzen 7 3700X': [0, 105, 0, 0, 0, 0.0092],
      'AMD Ryzen 5 5600X': [0, 65, 0, 0, 0, 0.008],
      'AMD Ryzen 5 3600X': [0, 95, 0, 0, 0, 0.007],
      'Intel i9-10900KF': [0, 125, 0, 0, 0, 0.0072],
      'Intel i9-10900K': [0, 125, 0, 0, 0, 0.0071],
      'Intel i9-9980XE': [0, 95, 0, 0, 0, 0.0098],
      'Intel i9-7980XE': [0, 95, 0, 0, 0, 0.0083],
      'Intel i9-7940X': [0, 95, 0, 0, 0, 0.0064],
      'Intel i9-7920X': [0, 95, 0, 0, 0, 0.00704],
      'Intel i9-7900X': [0, 95, 0, 0, 0, 0.00588],
      'Intel i7-10700KF': [0, 95, 0, 0, 0, 0.0064],
      'Intel i7-10700K': [0, 95, 0, 0, 0, 0.0063],
    },
  };

  static const int WATTS_IN_KILOWATT = 1000;
  static const MINUTES_IN_DAY = 1440;
  static const int HOURS_IN_DAY = 24;
  static const DAYS_IN_TWO_YEARS = 1825;

  static const NETWORK_HASHRATE = [149000000045000.0, 580230000.0, 321080000, 2566]; // TODO: Make this variable per day
  static const BLOCK_REWARD = [6.25, 2.0, 10000, 1.03];
  static const BLOCKTIME = [10.0, 0.25, 1, 2];
}
