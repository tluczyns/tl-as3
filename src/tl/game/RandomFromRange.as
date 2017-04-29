package tl.game {
	
	public class RandomFromRange {
		
		private var _arrProbability: Array;
		private var _maxValue: uint; 
		
		public function RandomFromRange(maxValue: uint) {
			this._maxValue = maxValue;
			this._arrProbability = new Array(maxValue);
			for (var i: uint = 0; i < maxValue; i++) {
				this._arrProbability[i] = 1;
			}
		}

		public function get value(): uint {
			var random: Number = Math.random() * this._maxValue;
			var value: uint = 0;
			random -= this._arrProbability[value];
			while (random > 0) {
				value++;
				if (value >= this._maxValue) break;
				random -= this._arrProbability[value];
			}
			this._arrProbability[value] *= 0.5;
			var probabilityToSubstractFromOther: Number = this._arrProbability[value] / (this._maxValue - 1);
			for (var i: uint = 0; i < this._maxValue; i++)
				if (i != value) this._arrProbability[i] += probabilityToSubstractFromOther;
			return value;
		} 
		
	}

}