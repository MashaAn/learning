import {Rule} from "./rule";

export class RuleBuilder {
    private denominators: number[] = [];

    public denominator(denominator: number): RuleBuilder {
        this.denominators.push(denominator);
        return this;
    }

    public returning(result: string): Rule {
        return new Rule(result, this.denominators);
    }
}
