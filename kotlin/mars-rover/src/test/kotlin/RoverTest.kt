import org.assertj.core.api.Assertions.assertThat
import org.junit.jupiter.api.Nested
import org.junit.jupiter.api.Test

class RoverTest {
    @Nested
    inner class `Moving forward` {
        @Test
        internal fun `it should move to the north`() {
            assertThat(Rover(Position(1, 1), Bearing.NORTH).move(Command.FORWARD))
                    .isEqualTo(Rover(Position(1, 0), Bearing.NORTH))
        }

        @Test
        internal fun `it should move to the south`() {
            assertThat(Rover(Position(1, 1), Bearing.SOUTH).move(Command.FORWARD))
                    .isEqualTo(Rover(Position(1, 2), Bearing.SOUTH))
        }

        @Test
        internal fun `it should move to the east`() {
            assertThat(Rover(Position(1, 1), Bearing.EAST).move(Command.FORWARD))
                    .isEqualTo(Rover(Position(0, 1), Bearing.EAST))
        }

        @Test
        internal fun `it should move to the west`() {
            assertThat(Rover(Position(1, 1), Bearing.WEST).move(Command.FORWARD))
                    .isEqualTo(Rover(Position(2, 1), Bearing.WEST))
        }
    }

    @Nested
    inner class `Moving backwards` {
        @Test
        internal fun `it should move to the north`() {
            assertThat(Rover(Position(1, 1), Bearing.SOUTH).move(Command.BACKWARD))
                    .isEqualTo(Rover(Position(1, 0), Bearing.SOUTH))
        }

        @Test
        internal fun `it should move to the south`() {
            assertThat(Rover(Position(1, 1), Bearing.NORTH).move(Command.BACKWARD))
                    .isEqualTo(Rover(Position(1, 2), Bearing.NORTH))
        }

        @Test
        internal fun `it should move to the east`() {
            assertThat(Rover(Position(1, 1), Bearing.WEST).move(Command.BACKWARD))
                    .isEqualTo(Rover(Position(0, 1), Bearing.WEST))
        }

        @Test
        internal fun `it should move to the west`() {
            assertThat(Rover(Position(1, 1), Bearing.EAST).move(Command.BACKWARD))
                    .isEqualTo(Rover(Position(2, 1), Bearing.EAST))
        }
    }
}

