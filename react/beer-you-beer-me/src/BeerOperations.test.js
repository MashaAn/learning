import {beerify, randomness, replaceWithBeer, takeWords, weight} from "./BeerOperations";

const seedrandom = require('seedrandom');
const fixedRng = seedrandom('test');

describe('Beer Operations', () => {
    describe('takeWords', () => {
        it('should tokenize sentence', () => {
            expect(takeWords('Word1 Word2 Word3')).toEqual(['Word1', 'Word2', 'Word3']);
        });
        it('should remove non-words', () => {
            expect(takeWords('Word1,.+#Word2')).toEqual(['Word1', 'Word2'])
        });
        it('should remove duplicate words', () => {
            expect(takeWords('Word1 Word1')).toEqual(['Word1'])
        });
    });
    describe('weight', () => {
        it('should attach value to each word', () => {
            expect(weight(['Word1', 'Word2'], () => 42)).toEqual([['Word1', 42], ['Word2', 42]]);
        });
        it('should attach randomness to each word', () => {
            expect(weight(['Word1', 'Word2'], randomness(fixedRng))).toEqual([['Word1', 87], ['Word2', 40]]);
        });
        it('should attach real randomness to each word', () => {
            const snd = ([_, value]) => value;
            weight(['Word1', 'Word2', 'Word3'], randomness())
                .map(snd)
                .forEach(num => {
                    expect(num).toBeLessThanOrEqual(100);
                    expect(num).toBeGreaterThanOrEqual(0);
                });
        });
    });
    describe('replace weighted words', () => {
        it('should replace all words below given frequency', () => {
            const sentence = 'Word1 Word2 Word3 Word4';
            const weights = [['Word1', 40], ['Word2', 10], ['Word3', 80], ['Word4', 50]];
            const replacement = replaceWithBeer(sentence, weights, 50);
            expect(replacement).toEqual('Beer Beer Word3 Beer');
        });
        it('should replace longer words first', () => {
            const sentence = 'a aaa';
            const weights = [['a', 0], ['aaa', 10]];
            const replacement = replaceWithBeer(sentence, weights, 10);
            expect(replacement).toEqual('Beer Beer');
        });
        it('should keep infix words', () => {
            const sentence = 'ways always';
            const weights = [['ways', 50], ['always', 100]];
            const replacement = replaceWithBeer(sentence, weights, 50);
            expect(replacement).toEqual('Beer always');
        });
        it('should replace word multiple times', () => {
            const sentence = 'ways ways ways ways';
            const weights = [['ways', 50]];
            const replacement = replaceWithBeer(sentence, weights, 50);
            expect(replacement).toEqual('Beer Beer Beer Beer');
        });
    });
    describe('beerify', () => {
        it('should beerify given sentence', () => {
            const result = beerify('Word1, Word2; Word3 -- Word4!', 50, fixedRng);
            expect(result).toEqual('Word1, Beer; Beer -- Beer!');
        });
    });
});