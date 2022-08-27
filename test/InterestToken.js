const InterestToken = artifacts.require('InterestToken');


contract('InterestToken',(accounts) => {
    let interestToken  = null;
    beforeEach(async() => {
        interestToken = await InterestToken.deployed();
    });

    it('Should get deployed', async() => {
        const add = await interestToken.address;
        assert(add != null);
    });

    it('Should return the name of the currency',async() => {
        const name = await interestToken.name();
        assert(name === "Interest token");
    });

    it('Should return the symbol of the currency',async() => {
        const symbol = await interestToken.symbol();
        assert(symbol === "INT");
    });

    it('Should return the total decimals',async() => {
        const decimals = await interestToken.decimals();
        assert(decimals.toNumber() == 18);
    });

    it('Should return the total supply',async() => {
        const totalSupply = await interestToken.totalSupply();
        assert(totalSupply.toNumber() == 210000);
    });
    

    it('Should mint coins', async () => {
        await interestToken.mint(1);
        const totalsupply = await interestToken.totalSupply();
        const balanceOfminter = await interestToken.balanceOf(accounts[0]);
        assert.strictEqual(totalsupply.toNumber(), 210001);
        assert.strictEqual(balanceOfminter.toNumber(), 210001);        
    });

    it('Should transfer the funds', async () => {
        const balanceBefore = await interestToken.balanceOf.call(accounts[ 0 ]);
        assert.strictEqual(balanceBefore.toNumber(), 210001);
    
        await interestToken.transfer(accounts[1],10);
    
        const balanceAfter = await interestToken.balanceOf.call(accounts[ 0 ]);
        const balanceOfaccount1 = await interestToken.balanceOf.call(accounts[ 1 ]);
        assert.strictEqual(balanceAfter.toNumber(), 209991);
        assert.strictEqual(balanceOfaccount1.toNumber(), 10);
      });

    it('Should allow others to speend the token upon approval', async () => {
        await interestToken.allowance(accounts[0],accounts[3]);
        await interestToken.approve(accounts[3],10,{ from: accounts[ 0 ] });
        await interestToken.transfer(accounts[4],10);
        const balance = await interestToken.balanceOf(accounts[4]);
        assert.strictEqual(balance.toNumber(), 10);     
    });

});