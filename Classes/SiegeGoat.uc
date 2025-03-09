class SiegeGoat extends GGMutator;

struct GoatCatapult
{
	var GGGoat mGoat;
	var CatapultVehicle mCatapult;
};
var array<GoatCatapult> mGoatCatapults;


/**
 * See super.
 */
function ModifyPlayer(Pawn Other)
{
	local GGGoat goat;

	goat = GGGoat( other );
	if( goat != none )
	{
		if( IsValidForPlayer( goat ) )
		{
			AddGoatCatapult(goat);
		}
	}

	super.ModifyPlayer( other );
}

function AddGoatCatapult(GGGoat goat)
{
	local GoatCatapult newGoatCatapult;

	if(mGoatCatapults.Find('mGoat', goat) == INDEX_NONE)
	{
		newGoatCatapult.mGoat=goat;
		mGoatCatapults.AddItem(newGoatCatapult);
	}
}

simulated event Tick( float deltaTime )
{
	local int i;

	super.Tick( deltaTime );

	for(i=0 ; i<mGoatCatapults.Length ; i++)
	{
		if(mGoatCatapults[i].mGoat == none || mGoatCatapults[i].mGoat.bPendingDelete)
			continue;

		if(mGoatCatapults[i].mCatapult == none || mGoatCatapults[i].mCatapult.bPendingDelete)
		{
			mGoatCatapults[i].mCatapult=Spawn(class'CatapultVehicle', mGoatCatapults[i].mGoat,, mGoatCatapults[i].mGoat.Location + (vect(0, 0, 1) * (3000 + (mGoatCatapults[i].mGoat.mCachedSlotNr * 1000))));
		}

		mGoatCatapults[i].mCatapult.currentBaseY=PlayerController( mGoatCatapults[i].mCatapult.Controller ).PlayerInput.aBaseY;
		mGoatCatapults[i].mCatapult.currentStrafe=PlayerController( mGoatCatapults[i].mCatapult.Controller ).PlayerInput.aStrafe;
	}
}

/**
 * Called when a pawn is possessed by a controller.
 */
function NotifyOnPossess( Controller C, Pawn P )
{
	local int i;

	super.NotifyOnPossess(C, P);

	for(i=0 ; i<mGoatCatapults.Length ; i++)
	{
		mGoatCatapults[i].mCatapult.NotifyOnPossess(C, P);
	}
}

/**
 * Called when a pawn is unpossessed by a controller.
 */
function NotifyOnUnpossess( Controller C, Pawn P )
{
	local int i;

	super.NotifyOnUnpossess(C, P);

	for(i=0 ; i<mGoatCatapults.Length ; i++)
	{
		mGoatCatapults[i].mCatapult.NotifyOnUnpossess(C, P);
	}
}

DefaultProperties
{

}