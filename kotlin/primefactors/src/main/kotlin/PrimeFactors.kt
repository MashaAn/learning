class PrimeFactors {

    companion object {
        fun of(number: Int): Iterable<Int> {
            val result = Result(number)
            for (factor in 2..5) {
                result.split(factor)
            }
            return result.list
        }
    }
}