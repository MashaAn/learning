import {ArabicConversion} from "./ArabicConversion";
import {Rule} from "./Rule";

export class Convert {
    public static toRomanNumber(arabic: number): string {
        const conversion = new ArabicConversion(arabic);
        Convert.chainOfRules.forEach((r) => conversion.apply(r));
        return conversion.result;
    }

    private static chainOfRules = [
        new Rule("C", 100),
        new Rule("L", 50),
        new Rule("X", 10),
        new Rule("IX", 9),
        new Rule("V", 5),
        new Rule("IV", 4),
        new Rule("I", 1),
    ];
}
